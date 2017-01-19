
# add copyright header

require './gc_common'
require './gc_stats_base'

class StatsPitchingStandard < StatsBase

    def initialize(fteam, team_id, fname, linitial, player_id)
        @uri_fmt   = GC_PLAYER_PITCHING_STANDARD_URI
        @stat_name = "stats_pitching_standard"
        super(fteam, team_id, fname, linitial, player_id)
    end

end
