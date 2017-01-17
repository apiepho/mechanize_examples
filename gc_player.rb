# add copyright header

require './gc_common'

class Player

    def initialize(team_href, player_json)
        # player data comes from roster data json from specific team page (given parameter)
=begin
# example player_json, one element from team roster json data
   {"b"=>"L",
    "formatted_name_mobile"=>"Andres Garcia",
    "formatted_name"=>"Andres Garcia",
    "pos"=>["P", "1B", "DH"],
    "lname"=>"Garcia",
    "num"=>"6",
    "t"=>"L",
    "fname"=>"Andres",
    "player_id"=>"56e4392543ee3f00211cb670",
    "wall_advice"=>[]},
=end
        $total_players += 1

        @name   = player_json["formatted_name"]
        @id     = player_json["player_id"]
        @number = (player_json["num"].nil? ? "-" : player_json["num"])
        @throws = (player_json["t"].nil?   ? "-" : player_json["t"])
        @bats   = (player_json["b"].nil?   ? "-" : player_json["b"])
        @positions = ""
        if not player_json["pos"].empty?
            player_json["pos"].each do |pos|
                @positions += pos
                @positions += " "
            end
        end

        # cycle thru player stat pages
        # TODO: build classes
        #   BattingStandard
        #   BattingSpeed
        #   BattingTeamImpact
        #   PitchingStandard
        #   PitchingEfficiency
        #   PitchingCommand
        #   PitchingBatterResults
        #   PitchingRuns
        #   PitchingPitchBreakdown
        #   FieldingStandard
        #   FieldingCatching
        #   SprayChart
        # NOTE: could build simpler uri like https://p/p-<id>/batting/standard
        #       but that would make it more difficult to inspect cache files
        temp     = team_href.split("/")
        temp     = temp[5].split("-")
        fteam    = temp[0]
        team_id  = temp[-1]
        fname    = player_json["fname"].downcase
        linitial = player_json["lname"].downcase[0]
        uri      = GC_PLAYER_BATTING_STANDARD_URI    % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_BATTING_SPEED_URI       % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_BATTING_TEAMIMPACT_URI  % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_PITCHING_STANDARD_URI   % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_PITCHING_EFFICIENCY_URI % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_PITCHING_COMMAND_URI    % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_PITCHING_BATTER_URI     % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_PITCHING_RUNS_URI       % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_PITCHING_PITCH_URI      % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_FIELDING_STANDARD_URI   % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_FIELDING_CATCHING_URI   % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
        uri      = GC_PLAYER_BATTING_SPRAY_URI       % [GC_BASE_URI, fteam, team_id, fname, linitial, @id]
        $browser.goto(uri)
        temp = $browser.html
    end

    def display
        puts "%s%s"   % [ $indent.str, @name ]
        puts "%s%s%s" % [ $indent.str, "player_id:   ", @id        ] if $options.debug
        puts "%s%s%s" % [ $indent.str, "number:      ", @number    ]
        puts "%s%s%s" % [ $indent.str, "throws:      ", @throws    ]
        puts "%s%s%s" % [ $indent.str, "bats:        ", @bats      ]
        puts "%s%s%s" % [ $indent.str, "position(s): ", @positions ]
    end

    def display_xml
        puts "<player>"
        puts "<name>%s</name>"           % @name
        puts "<id>%s</id>"               % @id
        puts "<number>%s</number>"       % @number
        puts "<throws>%s</throws>"       % @throws
        puts "<bats>%s</bats>"           % @bats
        puts "<positions>%s</positions>" % @positions
        puts "</player>"
    end
end

