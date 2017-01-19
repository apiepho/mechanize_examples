
# add copyright header

require './gc_common'
require './gc_stats_base'

class StatsPitchingPitchBreakdown < StatsBase

    def initialize(fteam, team_id, fname, linitial, player_id)
        @uri_fmt   = GC_PLAYER_PITCHING_PITCH_URI
        @stat_name = "stats_pitching_pitch"
        super(fteam, team_id, fname, linitial, player_id)
    end

end
