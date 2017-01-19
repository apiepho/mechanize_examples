
# add copyright header

require './gc_common'

class StatsPitchingRuns

    def initialize(fteam, team_id, fname, linitial, player_id)
        uri = GC_PLAYER_PITCHING_RUNS_URI % [GC_BASE_URI, fteam, team_id, fname, linitial, player_id]
        $browser.goto(uri)
        temp = $browser.html
        doc = Nokogiri::HTML($browser.html)
        totals = doc.css('totals_all')
        puts totals if $options.debug
        @param1 = "param1"
        @param2 = "param2"
        @param3 = "param3"
    end

    def display
        puts "%s%s" % [ $indent.str, "stats_pitching_runs: "]
        $indent.increase
        puts "%s%s%s" % [ $indent.str, "param1: ", @param1 ]
        puts "%s%s%s" % [ $indent.str, "param2: ", @param2 ]
        puts "%s%s%s" % [ $indent.str, "param3: ", @param3 ]
        $indent.decrease
    end

    def display_xml
        puts "<stats_pitching_runs>"
        puts "<param1>%s</param1>" % @param1
        puts "<param2>%s</param2>" % @param2
        puts "<param3>%s</param3>" % @param3
        puts "</stats_pitching_runs>"
    end
end
