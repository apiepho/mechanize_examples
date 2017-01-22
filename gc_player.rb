# add copyright header

require './gc_common'
require './gc_stats_base'
require './gc_stats_spray_chart'

class Player
	attr_reader :id, :name

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
        @stats_batting_standard    = StatsBase.new(    GC_PLAYER_BATTING_STANDARD_URI,       "stats_batting_standard", fteam, team_id, fname, linitial, @id)
        @stats_batting_speed       = StatsBase.new(       GC_PLAYER_BATTING_SPEED_URI,          "stats_batting_speed", fteam, team_id, fname, linitial, @id)
        @stats_batting_team_impact = StatsBase.new(  GC_PLAYER_BATTING_TEAMIMPACT_URI,    "stats_batting_team_impact", fteam, team_id, fname, linitial, @id)
        @stats_pitching_standard   = StatsBase.new(   GC_PLAYER_PITCHING_STANDARD_URI,      "stats_pitching_standard", fteam, team_id, fname, linitial, @id)
        @stats_pitching_efficiency = StatsBase.new( GC_PLAYER_PITCHING_EFFICIENCY_URI,    "stats_pitching_efficiency", fteam, team_id, fname, linitial, @id)
        @stats_pitching_command    = StatsBase.new(    GC_PLAYER_PITCHING_COMMAND_URI,       "stats_pitching_command", fteam, team_id, fname, linitial, @id)
        @stats_pitching_batter     = StatsBase.new(     GC_PLAYER_PITCHING_BATTER_URI,        "stats_pitching_batter", fteam, team_id, fname, linitial, @id)
        @stats_pitching_runs       = StatsBase.new(       GC_PLAYER_PITCHING_RUNS_URI,          "stats_pitching_runs", fteam, team_id, fname, linitial, @id)
        @stats_pitching_pitch      = StatsBase.new(      GC_PLAYER_PITCHING_PITCH_URI,         "stats_pitching_pitch", fteam, team_id, fname, linitial, @id)
        @stats_fielding_standard   = StatsBase.new(   GC_PLAYER_FIELDING_STANDARD_URI,      "stats_fielding_standard", fteam, team_id, fname, linitial, @id)
        @stats_fielding_catcher    = StatsBase.new(   GC_PLAYER_FIELDING_CATCHING_URI,       "stats_fielding_catcher", fteam, team_id, fname, linitial, @id)
        @stats_batting_spray_chart = StatsSprayChart.new( GC_PLAYER_BATTING_SPRAY_URI,     "stats_batting_spray_chart", fteam, team_id, fname, linitial, @id)
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
        @stats_batting_spray_chart.display_xml
        puts "</player>"
    end
end

