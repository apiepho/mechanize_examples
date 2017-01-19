# add copyright header


require './gc_common'
require './gc_team'

class Teams
    def initialize()
        # teams data can be found in the teams page

        # go to teams page
        $browser.goto(GC_TEAMS_URI)

        # team links have href that includes /t/
        doc = Nokogiri::HTML($browser.html)
        temp = doc.css('a').map { |link| link['href'] }
        links = []
        temp.each do |link|
            # all links are full path
            links << "%s%s" % [GC_BASE_URI, link.strip] if not link.nil? and link.include?('/t/')
        end
        links = links.uniq

        @teams = []
        links.each do |link|
            next if not supported_team(link)
            if $options.list
                puts link
            else
                team = Team.new(link)
                @teams << team
            end
        end
    end

    def supported_team(href)
        result = true
        if result and not $options.year.nil?
            result = false
            result = true if href.include?($options.year + "/")
        end
        if result and not $options.season.nil?
            result = false
            result = true if href.include?("/" + $options.season.downcase)
        end
        if result and not $options.teams.nil?
            result = false
            parts = $options.teams.split(",")
            parts.each do |part|
                result = true if href.include?("/" + part.strip)
            end
        end
        result
    end

    def display_xml()
        puts "<teams>"
        @teams.each do |team|
            team.display_xml
        end
        puts "<total_teams>%d</total_teams>"     % $total_teams
        puts "<total_players>%d</total_players>" % $total_players
        puts "<total_games>%d</total_games>"     % $total_games
        puts "</teams>"
    end
end
