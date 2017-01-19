
# add copyright header

require './gc_common'

class StatsBattingStandard

    def initialize(fteam, team_id, fname, linitial, player_id)
        uri = GC_PLAYER_BATTING_SPEED_URI % [GC_BASE_URI, fteam, team_id, fname, linitial, player_id]
        $browser.goto(uri)
        temp = $browser.html
        
        # look thru all the th elements to find stats and TLA
        @names = []
        @syms  = []
        @vals  = []
        doc = Nokogiri::HTML($browser.html)
        ths = doc.css('th')
        ths.each do |th|
            data_stat_name = th.attribute('data-stat-name')
            inner_html     = th.inner_html.strip
            @names << data_stat_name if not data_stat_name.nil?
            @syms  << inner_html     if not data_stat_name.nil?
        end
        
        # grab values from total row
        tr = doc.css('.totals_all')
        tds = tr.css('td')
        tds.each do |td|
            inner_html = td.inner_html.strip
            @vals  << inner_html if not inner_html.include?("All")
        end
    end

    def display
        puts "%s%s" % [ $indent.str, "stats_batting_standard: "]
        $indent.increase
        str = ""
        @syms.each do |sym|
            str += "%-8s" % sym
        end
        puts "%s%s" % [ $indent.str, str ]
        str = ""
        @vals.each do |val|
            str += "%-8s" % val
        end
        puts "%s%s" % [ $indent.str, str ]
        $indent.decrease
    end

    def display_xml
        puts "<stats_batting_standard>"
        @syms.each_with_index do |sym, index|
            name = @names[index].to_s
            name = name.downcase
            name = name.gsub(" ", "_")
            name = name.gsub("%", "_percent_")
            name = name.gsub("/", "_per_")
            val  = @vals[index]
        	puts "<%s>" % name
        	puts "<sym>%s</sym>" % sym
        	puts "<val>%s</val>" % val
        	puts "</%s>" % name
        end
        puts "</stats_batting_standard>"
    end
end
