# add copyright header

require './gc_common'
require './gc_games'
require './gc_roster'

class Team

    def initialize(team_href)
        puts team_href if $options.debug
        # team data comes from 2 parts:
        # 1. data gleened from the specific team page href (given parameter)
        # 2. data from the specfic team page
        $total_teams += 1

        # parse the team href
        # using http://rubular.com/ to figure out regex for something like
        # "/t/spring-2016/roosevelt-rough-riders-varsity-56dfa90020277d0024b46bbb"
        match = team_href.match(/\/t\/([a-z]+)-([0-9]+)\/([a-z0-9-]+)-([a-z0-9]+\z)/).to_a
        # should produce:
        # match[0] = /t/spring-2016/roosevelt-rough-riders-varsity-56dfa90020277d0024b46bbb
        # match[1] = spring
        # match[2] = 2016
        # match[3] = roosevelt-rough-riders-varsity
        # match[4] = 56dfa90020277d0024b46bbb
        @href = team_href
        @name   = match[3].gsub("-", " ").split.map{|i| i.capitalize}.join(' ')
        @season = match[1].capitalize
        @year   = match[2]
        @guid   = match[4]

        # get roster
        # counter intuitive to get roster before team, but team page consists mainly of
        # games data
        @roster = Roster.new(@href)

        # get the team page to get game record and game json data
        $browser.goto(@href)

        # from team page, get city and sport that is shown under team name
        doc = Nokogiri::HTML($browser.html)
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
        json_decoded = $gc_parse.decode($browser.html)
        json_decoded = json_decoded.reverse           # games are listed in newest first

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
        @games = Games.new(json_decoded)
    end

    def supported_game(game_json)
        result = true
         result = false if not $options.games.nil? and @games.length >= $options.games.to_i
        result = false if game_json.nil? or game_json["game_id"].nil?
        result
    end

    def display_xml
        puts "<team>"
        puts "<name>%s</name>"     %  @name
        puts "<href>%s</href>"     %  @href
        puts "<guid>%s</guid>"     %  @guid
        puts "<city>%s</city>"     %  @city
        puts "<sport>%s</sport>"   %  @sport
        puts "<season>%s</season>" %  @season
        puts "<year>%s</year>"     %  @year
        puts "<wins>%d</wins>"     %  @wins
        puts "<loses>%d</loses>"   % @losses
        puts "<ties>%d</ties>"     % @ties
        @roster.display_xml
        @games.display_xml
        puts "</team>"
    end
end

