# add copyright header

require './gc_common'
require './gc_stats_batting_standard'
require './gc_stats_batting_speed'
require './gc_stats_batting_team_impact'
require './gc_stats_pitching_standard'
require './gc_stats_pitching_efficiency'
require './gc_stats_pitching_command'
require './gc_stats_pitching_batter'
require './gc_stats_pitching_runs'
require './gc_stats_pitching_pitch'
require './gc_stats_fielding_standard'
require './gc_stats_fielding_catcher'
require './gc_stats_spray_chart'

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
        temp     = team_href.split("/")
        temp     = temp[5].split("-")
        fteam    = temp[0]
        team_id  = temp[-1]
        fname    = player_json["fname"].downcase
        linitial = player_json["lname"].downcase[0]
        @stats_batting_standard    = StatsBattingStandard.new(fteam, team_id, fname, linitial, @id)
        @stats_batting_speed       = StatsBattingSpeed.new(fteam, team_id, fname, linitial, @id)
        @stats_batting_team_impact = StatsBattingTeamImpact.new(fteam, team_id, fname, linitial, @id)
        @stats_pitching_standard   = StatsPitchingStandard.new(fteam, team_id, fname, linitial, @id)
        @stats_pitching_efficiency = StatsPitchingEfficiency.new(fteam, team_id, fname, linitial, @id)
        @stats_pitching_command    = StatsPitchingCommand.new(fteam, team_id, fname, linitial, @id)
        @stats_pitching_batter     = StatsPitchingBatterResults.new(fteam, team_id, fname, linitial, @id)
        @stats_pitching_runs       = StatsPitchingRuns.new(fteam, team_id, fname, linitial, @id)
        @stats_pitching_pitch      = StatsPitchingPitchBreakdown.new(fteam, team_id, fname, linitial, @id)
        @stats_fielding_standard   = StatsFieldingStandard.new(fteam, team_id, fname, linitial, @id)
        @stats_fielding_catcher    = StatsFieldingCatching.new(fteam, team_id, fname, linitial, @id)
        @stats_spray_chart         = StatsSprayChart.new(fteam, team_id, fname, linitial, @id)
    end

    def display
        puts "%s%s"   % [ $indent.str, @name ]
        puts "%s%s%s" % [ $indent.str, "player_id:   ", @id        ] if $options.debug
        puts "%s%s%s" % [ $indent.str, "number:      ", @number    ]
        puts "%s%s%s" % [ $indent.str, "throws:      ", @throws    ]
        puts "%s%s%s" % [ $indent.str, "bats:        ", @bats      ]
        puts "%s%s%s" % [ $indent.str, "position(s): ", @positions ]
        puts "%s%s"   % [ $indent.str, "stats: " ]
        $indent.increase
        @stats_batting_standard.display
        @stats_batting_speed.display
        @stats_batting_team_impact.display
        @stats_pitching_standard.display
        @stats_pitching_efficiency.display
        @stats_pitching_command.display
        @stats_pitching_batter.display
        @stats_pitching_runs.display
        @stats_pitching_pitch.display
        @stats_fielding_standard.display
        @stats_fielding_catcher.display
        @stats_spray_chart.display
        $indent.decrease
    end

    def display_xml
        puts "<player>"
        puts "<name>%s</name>"           % @name
        puts "<id>%s</id>"               % @id
        puts "<number>%s</number>"       % @number
        puts "<throws>%s</throws>"       % @throws
        puts "<bats>%s</bats>"           % @bats
        puts "<positions>%s</positions>" % @positions
        @stats_batting_standard.display_xml
        @stats_batting_speed.display_xml
        @stats_batting_team_impact.display_xml
        @stats_pitching_standard.display_xml
        @stats_pitching_efficiency.display_xml
        @stats_pitching_command.display_xml
        @stats_pitching_batter.display_xml
        @stats_pitching_runs.display_xml
        @stats_pitching_pitch.display_xml
        @stats_fielding_standard.display_xml
        @stats_fielding_catcher.display_xml
        @stats_spray_chart.display_xml
        puts "</player>"
    end
end

