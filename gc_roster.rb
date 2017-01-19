# add copyright header

require './gc_common'
require './gc_player'

class Roster
    def initialize(team_href)
        # roster data can be found in the teams roster page

        # go to team roster page
        uri = GC_ROSTER_URI % team_href
        $browser.goto(uri)

        #pp $browser.html
        temp = $browser.html
        json_encoded = temp.match(/initialize\(\$\.parseJSON.*$/)              # get the JSON data with GC roster data
        json_encoded = json_encoded.to_s                                       # convert MatchData to a string
        json_encoded = json_encoded.gsub("\\u0022", "\"")                      # convert unicode quote
        json_encoded = json_encoded.gsub("\\u002D", "-")                       # convert unicode hyphen
        json_encoded = json_encoded.gsub("initialize\(\$\.parseJSON\(\"", "")  # remove leading cruft
        json_encoded = json_encoded.gsub("\"\), false, false\);", "")          # remove trailing cruft
        json_decoded = JSON.parse json_encoded                                 # conver to a hash

        @players = []
        json_decoded["roster"].each do |player_json|
            next if not $options.roster.nil? and @players.length >= $options.roster.to_i
            @players << Player.new(team_href, player_json)
        end

        # merge duplicate players
    end


    def display_xml()
        puts "<roster>"
        @players.each do |player|
            player.display_xml
        end
        puts "</roster>"
    end
end

