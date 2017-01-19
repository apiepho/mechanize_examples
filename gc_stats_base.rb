
# add copyright header

require './gc_common'

class StatsBase

    def initialize(uri_fmt, stat_name, fteam, team_id, fname, linitial, player_id)
        @stat_name = stat_name
        uri = uri_fmt % [GC_BASE_URI, fteam, team_id, fname, linitial, player_id]
        $browser.goto(uri)
        temp = $browser.html

        # look thru all the th elements to find stats and TLA
        @names = []
        @syms  = []
        @vals  = []
        doc = Nokogiri::HTML($browser.html)
        ths = doc.css('th')
        ths.each do |th|
            data_stat_name = th.attribute('data-stat-name').to_s
            inner_html     = th.inner_html.strip
            if not data_stat_name.empty?
                data_stat_name = data_stat_name.gsub("&", "&amp;")
                @names << data_stat_name
                @syms  << inner_html
            end
        end

        # grab values from total row
        tr = doc.css('.totals_all')
        tds = tr.css('td')
        tds.each do |td|
            inner_html = td.inner_html.strip
            @vals  << inner_html if not inner_html.include?("All")
        end
    end

    def display_xml
        puts "<%s>" % @stat_name
        @syms.each_with_index do |sym, index|
            xml_name = sym
            xml_name = xml_name.gsub("%", "_percent_")
            xml_name = xml_name.gsub("/", "_per_")
            xml_name = xml_name.gsub("+", "_plus_")
            xml_name = xml_name.gsub("#", "_num_")
            xml_name = xml_name.gsub("&lt;", "_less_")
            xml_name = xml_name.gsub(":", "")
            xml_name = xml_name.gsub("(", "")
            xml_name = xml_name.gsub(")", "")
            xml_name = xml_name.gsub(" ", "")
            name = @names[index]
            val  = @vals[index]
            puts "<_%s_>" % xml_name
             puts "<name>%s</name>" % name
               puts "<sym>%s</sym>"   % sym
            puts "<val>%s</val>"   % val
            puts "</_%s_>" % xml_name
        end
        puts "</%s>" % @stat_name
    end
end
