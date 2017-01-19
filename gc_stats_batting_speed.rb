
# add copyright header

require './gc_common'
require './gc_stats_base'

class StatsBattingSpeed < StatsBase

    def initialize(fteam, team_id, fname, linitial, player_id)
        @uri_fmt   = GC_PLAYER_BATTING_SPEED_URI
        @stat_name = "stats_batting_speed"
        super(fteam, team_id, fname, linitial, player_id)
    end

end
