require 'mechanize'
require 'json'

email = 'alpiepho@yahoo.com'
password = 'jjjzzzkkk'
GC_BASE_URI  = 'https://gc.com'
GC_LOGIN_URI = GC_BASE_URI + '/login'
GC_TEAM_MAX  = '100'
GC_TEAMS_URI = GC_BASE_URI + '/teams?page_number=0&page_size=' + GC_TEAM_MAX


class Team
    #attr_accessor :complex_name
    #attr_accessor :relative_href
    #attr_accessor :href
    #attr_accessor :name
# possible fields
#    .parsed_name
#    .parsed_href
#    .name
#    .sport
#    .season
#    .year
#    .total_games
#    .games


	def initialize(mechanize, complex_name, relative_href)
	    # save given params
	    @mechanize = mechanize
		@complex_name = complex_name
		@relative_href = relative_href

        # parse the params
		@name = complex_name.gsub("Baseball", "").gsub("Softball", "").gsub("Fan", "").gsub("·", "").strip
		@href = GC_BASE_URI + @relative_href
		parts = relative_href.split("/")
		parts = parts[2].split("-")
		@season = parts[0].strip.capitalize
		@year = parts[1].strip
		
		# get info from the team page
		page = mechanize.get(@href)
        #puts "======================="
        #puts @name
        #puts page.body
        
        # on team page, get city and sport that is shown under team name
        temp   = page.parser.css('.pll h2').text.gsub("\n", "").strip
        temp   = page.parser.css('.pll h3').text.gsub("\n", "").strip if temp.length == 0 # tournaments use h3
        parts  = temp.split("·")
        @city  = "-"
        @sport = "-"
        @city  = parts[0].strip if parts.length == 2  # normal display for teams
        @sport = parts[1].strip if parts.length == 2  # normal display for teams
        @sport = parts[0].strip if parts.length == 1  # tournaments don't show city

        # parse game summary from team page
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

        # compute W-L-T record from game json game summary
        @wins   = 0
        @losses = 0
        @ties   = 0
        json_decoded.each do |game|
			@wins   += 1 if game["result"] === "W"
			@losses += 1 if game["result"] === "L"
			@ties   += 1 if game["result"] === "T"
        end        
 
	end
	
	def display(full = false)
		puts "%s"         % @name
		puts "  %s"       % @complex_name   if full
		puts "  %s"       % @relative_href  if full
		puts "  %s"       % @href
		puts "  %s"       % @city
		puts "  %s"       % @sport
		puts "  %s-%s"    % [@season, @year]
		puts "  %d-%d-%d" % [@wins, @losses, @ties]
	end
end

def dump_teams(teams)
	teams.each do |team|
	  #team.display(full=true)
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
#pp page.body

# using href that start with /t/ and include 
team_links = []
page.links.each do |link|
    team_links << link if link.href.to_s.start_with?('/t/') and link.text.include?(' Fan ')
end

teams = []
team_links.each do |link|
    next if not (link.text.include?("Rough") or link.text.include?("Xplosion"))
    team = Team.new(mechanize, link.text, link.href)
    teams << team
end

dump_teams(teams)







