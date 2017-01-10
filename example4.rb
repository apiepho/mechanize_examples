require 'json'
require 'nokogiri'
require 'optparse'
require 'ostruct'
require 'pp'
require 'watir'

GC_BASE_URI  = 'https://gc.com'
GC_LOGIN_URI = GC_BASE_URI + '/login'
# assume no one will follow more than 1000 teams
#GC_TEAMS_URI = GC_BASE_URI + '/teams?page_number=0&page_size=1000'
# NOTE: since we are parsong json instead of html, don't need to set page_size
GC_TEAMS_URI = GC_BASE_URI + '/teams'

# debug/status
$total_teams = 0
$total_games = 0

class Game
    attr_accessor :score_us, :score_them

	def initialize(browser, options, game_json)
		$total_games += 1
		@json = game_json
		uri = GC_BASE_URI + "/game-" + @json["game_id"] + "/plays"
		browser.goto(uri)
      
		# get body as a string, waiting for javascript to finish populating
		temp = browser.html
    	seconds = 0
    	while not temp.include?(" inning_1_half_0 \"") and seconds < 30 do
        	sleep(1)
			seconds += 1
        	temp = browser.html
		end
=begin
	json_encoded = temp.match(/initialize\(\$\.parseJSON.*$/)              # get the JSON data with GC game data
	json_encoded = json_encoded.to_s                                       # convert MatchData to a string
	json_encoded = json_encoded.gsub("\\u0022", "\"")                      # convert unicode quote
	json_encoded = json_encoded.gsub("\\u002D", "-")                       # convert unicode hyphen
	json_encoded = json_encoded.gsub("initialize\(\$\.parseJSON\(\"", "")  # remove leading cruft
	json_encoded = json_encoded.gsub("\"\), \$\(\'body\'\)\);", "")        # remove trailing cruft
	json_decoded = JSON.parse json_encoded                                 # conver to a hash
	pp json_decoded
=end
end
    
	def display
=begin
		# example game_json, one element from team json data
		{"home_won"=>false,
		 "away_won"=>true,
		 "arrival_ts"=>nil,
		 "playstatus"=>"CPT",
		 "meta"=>{"offline"=>true},
		 "result"=>"L",
		 "home"=>true,
		 "timezone"=>-7.0,
		 "utc_start"=>"2016-03-12T19:00:00",
		 "sport"=>"BASEB",
		 "team_name"=>"Roosevelt",
		 "recap_title"=>
		  "Eaton (CO) pulls away late for 12-4 victory over Roosevelt Rough Riders Varsity ",
		 "state"=>
		  {"status"=>"CPT",
		   "inning"=>10,
		   "side_readable"=>"Top",
		   "away"=>12,
		   "x"=>"st",
		   "w"=>"v",
		   "half"=>0,
		   "home"=>4,
		   "side"=>0},
		 "location"=>"Nelson Field 4",
		 "play_time"=>"2016-03-12T12:00:00",
		 "type"=>"Exhibition",
		 "save_ts"=>1457829771.0,
		 "recipients"=>[],
		 "wl"=>"0-0-0",
		 "other_team_id"=>"56e4c51a57a7013ee2000001",
		 "game_id"=>"56e4c51a57a7013ef9000002",
		 "uses_halves"=>false,
		 "notes"=>"",
		 "recapstatus"=>"CPT",
		 "stream_id"=>"56e428119ddd0a3f1f000001",
		 "minutes_before"=>0,
		 "other_team_name"=>"Eaton"}
=end
        at_vs        = (@json["home"] === "home" ? "vs" : "at")
		win_lose_tie = "win"   if (@json["result"] === "W")
		win_lose_tie = "loss"  if (@json["result"] === "L")
		win_lose_tie = "tie"   if (@json["result"] === "T")
        score_home   = @json["state"]["home"].to_i
        score_away   = @json["state"]["away"].to_i
        @score_us    = (@json["home"] ? score_home : score_away)
        @score_them  = (@json["home"] ? score_away : score_home)

		puts "    %s %s" % [at_vs, @json["other_team_name"]]
		puts "      %s" % @json["utc_start"]
		#puts "      game_id:  %s" % @json["game_id"]
		puts "      location: %s" % (@json["location"].empty? ? "-" : @json["location"])
		puts "      us:       %s" % @score_us
		puts "      them:     %s" % @score_them
		puts "      result:   %s" % win_lose_tie
		puts "      recap:    %s" % @json["recap_title"]
	end
end

class Team

	def supported_game(options, game_json)
		result = true
     	result = false if not options.games.nil? and @games.length >= options.games.to_i
        result = false if game_json.nil? or game_json["game_id"].nil?
        result
	end

	def initialize(browser, options, href)
		$total_teams += 1

		# parse the team href
		# using http://rubular.com/ to figure out regex for something like
		# "/t/spring-2016/roosevelt-rough-riders-varsity-56dfa90020277d0024b46bbb"
		match = href.match(/\/t\/([a-z]+)-([0-9]+)\/([a-z0-9-]+)-([a-z0-9]+\z)/).to_a
		# should produce:
		# match[0] = /t/spring-2016/roosevelt-rough-riders-varsity-56dfa90020277d0024b46bbb
		# match[1] = spring
		# match[2] = 2016
		# match[3] = roosevelt-rough-riders-varsity
		# match[4] = 56dfa90020277d0024b46bbb
		@href = href
		@name   = match[3].gsub("-", " ").split.map{|i| i.capitalize}.join(' ')
		@season = match[1].capitalize
		@year   = match[2]
		@guid   = match[4]
      
		# get the team page
		browser.goto(@href)
        
		# from team page, get city and sport that is shown under team name
		doc = Nokogiri::HTML(browser.html)
		temp   = doc.css('.pll h2').text.gsub("\n", "").strip
		temp   = doc.css('.pll h3').text.gsub("\n", "").strip if temp.length == 0 # tournaments use h3
		parts  = temp.split("·")
		@city  = "-"
		@sport = "-"
		@city  = parts[0].strip if parts.length == 2  # normal display for teams
		@sport = parts[1].strip if parts.length == 2  # normal display for teams
		@sport = parts[0].strip if parts.length == 1  # tournaments don't show city

		# from team page, parse game summary
		# mechanize/nokogiri do NOT run javascript, but GC passes game summary data as a JSON string
		# watir can get html AFTER javascript, but full set of team json if always give, so this
		# way we don't need special uri for teams.
		temp = browser.html                                        # get body as a string
		json_encoded = temp.match(/ \$\.parseJSON.*$/)             # get the JSON data with GC game data
		json_encoded = json_encoded.to_s                           # convert MatchData to a string
		json_encoded = json_encoded.gsub("\\u0022", "\"")          # convert unicode quote
		json_encoded = json_encoded.gsub("\\u002D", "-")           # convert unicode hyphen
		json_encoded = json_encoded.gsub(" \$\.parseJSON(\'", "")  # remove leading cruft
		json_encoded = json_encoded.gsub("\'),", "")               # remove trailing cruft
		json_decoded = JSON.parse json_encoded                     # conver to a hash

		# from json game summary, compute W-L-T record and build list of Games
		@wins   = 0
		@losses = 0
		@ties   = 0
		json_decoded.each do |game_json|
			@wins   += 1 if game_json["result"] === "W"
			@losses += 1 if game_json["result"] === "L"
			@ties   += 1 if game_json["result"] === "T"
		end        

		# from json game summary,  build list of Games
		@games = []
		json_decoded.each do |game_json|
			next if not supported_game(options, game_json)
			@games << Game.new(browser, options, game_json)
		end
		# games are listed in newest first
        @games = @games.reverse
 
	end
   
	def display
		puts "%s"         % @name
		puts "  %s"       % @href
		#puts "  %s"       % @guid
		puts "  %s"       % @city
		puts "  %s"       % @sport
		puts "  %s-%s"    % [@season, @year]
		puts "  %d-%d-%d" % [@wins, @losses, @ties]
		@games.each do |game|
			game.display
		end
	end
end

def supported_team(year, season, teams, href)
	result = true
	if result and not year.nil?
		result = false
		result = true if href.include?(year + "/")
	end
	if result and not season.nil?
		result = false
		result = true if href.include?("/" + season.downcase)
	end
	if result and not teams.nil?
		result = false
		parts = teams.split(",")
		parts.each do |part|
			result = true if href.include?("/" + part.strip)
		end
	end
	result
end

def dump_teams(teams)
	teams.each do |team|
		team.display
	end
	puts $total_teams
	puts $total_games
end


# parse command line options
options = OpenStruct.new
parser = OptionParser.new do |opt|
	opt.on('-e', '--email    <email>',                   '(required) login email for GameChanger')                         { |o| options.email    = o }
	opt.on('-p', '--password <password>',                '(required) login password for GameChanger')                      { |o| options.password = o }
	opt.on('-l', '--list',                               '(optional) list team urls')                                      { |o| options.list     = true }
	opt.on('-y', '--year <YYYY>',                        '(optional) specific year')                                       { |o| options.year     = o }
	opt.on('-s', '--season <spring|summer|fall|winter>', '(optional) specfic season')                                      { |o| options.season   = o }
	opt.on('-t', '--teams <teams>',                      '(optional) list of sub strings to limit teams (separated by ,)') { |o| options.teams    = o }
	opt.on('-g', '--games <games>',                      '(debug)    limit games')                                         { |o| options.games    = o }
end
parser.parse!

if options.email.nil? or options.password.nil?
	puts "Error: must provide email and password."
	puts parser.help
	exit
end

# get a new instance of Watir class (NOTE: need chromedriver in path, 
# get chromedriver from https://sites.google.com/a/chromium.org/chromedriver/downloads)
browser = Watir::Browser.new

# login
browser.goto(GC_LOGIN_URI)
browser.text_field(:id,'email').set(options.email)
browser.text_field(:id,'login_password').set(options.password)
browser.form(:id,'frm_login').submit

# go to teams page
browser.goto(GC_TEAMS_URI)

# team links have href that includes /t/
team_links = []
browser.links.to_a.each do |link|
	team_links << link.href if link.href.to_s.include?('/t/')
end
team_links = team_links.uniq

teams = []
team_links.each do |link|
	next if not supported_team(options.year, options.season, options.teams, link)
	if options.list
		puts link
	else
		team = Team.new(browser, options, link)
		teams << team
   end
end

dump_teams(teams) if not options.list

