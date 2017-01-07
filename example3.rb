require 'mechanize'
require 'json'

# TODO: pass is as params or config file
email        = 'alpiepho@yahoo.com'
password     = 'jjjzzzkkk'

GC_BASE_URI  = 'https://gc.com'
GC_LOGIN_URI = GC_BASE_URI + '/login'
GC_TEAMS_URI = GC_BASE_URI + '/teams?page_number=0&page_size=1000' # assume no one will follow more than 1000 teams

class Game
    def initialize(mechanize, game_json)
    @json = game_json
# example game_json
=begin
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
    end
    
    def display
        puts "    %s"   % @json["game_id"]
        puts "      %s" % (@json["location"].empty? ? "-" : @json["location"])
        puts "      %s" % @json["result"]
    end
end

class Team

	def initialize(mechanize, relative_href)

        # parse the team relative href
		@href = GC_BASE_URI + relative_href
		# using http://rubular.com/ to figure out regex for something like
		# "/t/spring-2016/roosevelt-rough-riders-varsity-56dfa90020277d0024b46bbb"
		match = relative_href.match(/\/t\/([a-z]+)-([0-9]+)\/([a-z0-9-]+)-([a-z0-9]+\z)/).to_a
		# should produce:
		# match[0] = /t/spring-2016/roosevelt-rough-riders-varsity-56dfa90020277d0024b46bbb
		# match[1] = spring
		# match[2] = 2016
		# match[3] = roosevelt-rough-riders-varsity
		# match[4] = 56dfa90020277d0024b46bbb
		@name   = match[3].gsub("-", " ").split.map{|i| i.capitalize}.join(' ')
		@season = match[1].capitalize
		@year   = match[2]
		@guid   = match[4]
		
		# get the team page
		page = mechanize.get(@href)
        
        # from team page, get city and sport that is shown under team name
        temp   = page.parser.css('.pll h2').text.gsub("\n", "").strip
        temp   = page.parser.css('.pll h3').text.gsub("\n", "").strip if temp.length == 0 # tournaments use h3
        parts  = temp.split("·")
        @city  = "-"
        @sport = "-"
        @city  = parts[0].strip if parts.length == 2  # normal display for teams
        @sport = parts[1].strip if parts.length == 2  # normal display for teams
        @sport = parts[0].strip if parts.length == 1  # tournaments don't show city

        # from team page, parse game summary
        # mechanize/nokogiri do NOT run javascript, but GC passes game summary data as a JSON string
        # TODO: try watir or selenium to get html AFTER javascript???
        temp = page.body                                           # get body as a string
        json_encoded = temp.match(/ \$\.parseJSON.*$/)             # get the JSON data with GC game data
        json_encoded = json_encoded.to_s                           # convert MatchData to a string
        json_encoded = json_encoded.gsub("\\u0022", "\"")          # convert unicode quote
        json_encoded = json_encoded.gsub("\\u002D", "-")           # convert unicode hyphen
        json_encoded = json_encoded.gsub(" \$\.parseJSON(\'", "")  # remove leading cruft
        json_encoded = json_encoded.gsub("\'),", "")               # remove traikling cruft
        json_decoded = JSON.parse json_encoded                     # conver to a hash

        # from json game summary, compute W-L-T record and build list of Games
        @wins   = 0
        @losses = 0
        @ties   = 0
        @games = []
        json_decoded.each do |game_json|
			@wins   += 1 if game_json["result"] === "W"
			@losses += 1 if game_json["result"] === "L"
			@ties   += 1 if game_json["result"] === "T"
			@games << Game.new(mechanize, game_json)
        end        
 
	end
	
	def display
		puts "%s"         % @name
		puts "  %s"       % @href
		puts "  %s"       % @guid
		puts "  %s"       % @city
		puts "  %s"       % @sport
		puts "  %s-%s"    % [@season, @year]
		puts "  %d-%d-%d" % [@wins, @losses, @ties]
		@games.each do |game|
		    game.display
		end
	end
end

def dump_teams(teams)
	teams.each do |team|
	  team.display
	end
	puts "total: %d" % teams.length
end

# get a new instance of Mechanize class
mechanize = Mechanize.new

# login
page = mechanize.get(GC_LOGIN_URI)
form = page.forms.first

form['email']    = email
form['password'] = password
form.submit

# get teams
page = mechanize.get(GC_TEAMS_URI)

# team links have href that start with /t/ and include 
team_links = []
page.links.each do |link|
    team_links << link if link.href.to_s.start_with?('/t/') and link.text.include?(' Fan ')
end

teams = []
team_links.each do |link|
    next if not (link.text.include?("Rough") or link.text.include?("Xplosion")) # debug, limit teams
    team = Team.new(mechanize, link.href)
    teams << team
end

dump_teams(teams)







