
# add copyright header

require './gc_common'
require './gc_stats_base'

class StatsPitchingRuns < StatsBase

    def initialize(fteam, team_id, fname, linitial, player_id)
        @uri_fmt   = GC_PLAYER_PITCHING_RUNS_URI
        @stat_name = "stats_pitching_runs"
        super(fteam, team_id, fname, linitial, player_id)
    end

end
