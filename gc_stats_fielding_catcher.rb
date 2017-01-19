
# add copyright header

require './gc_common'
require './gc_stats_base'

class StatsFieldingCatching < StatsBase

    def initialize(fteam, team_id, fname, linitial, player_id)
        @uri_fmt   = GC_PLAYER_FIELDING_CATCHING_URI
        @stat_name = "stats_fielding_catcher"
        super(fteam, team_id, fname, linitial, player_id)
    end

end
