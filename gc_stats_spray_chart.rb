
# add copyright header

require './gc_common'
require './gc_stats_base'

class StatsSprayChart < StatsBase

    def initialize(uri_fmt, stat_name, fteam, team_id, fname, linitial, player_id)
    	super(uri_fmt, stat_name, fteam, team_id, fname, linitial, player_id)
    	
    	# need to redo since spray chart table is differnet format
        @names = []
        @syms  = []
        @vals  = []
        doc = Nokogiri::HTML($browser.html)

        @names << "Batting Tendency Outfield Total"
        @syms  << "tof"
        @vals  << doc.css('td#tof').inner_html.strip
        @names << "Batting Tendency Outfield Left"
        @syms  << "lof"
        @vals  << doc.css('td#lof').inner_html.strip
        @names << "Batting Tendency Outfield Center"
        @syms  << "cof"
        @vals  << doc.css('td#cof').inner_html.strip
        @names << "Batting Tendency Outfield Right"
        @syms  << "rof"
        @vals  << doc.css('td#rof').inner_html.strip

        @names << "Batting Tendency Infield Total"
        @syms  << "tif"
        @vals  << doc.css('td#tif').inner_html.strip
        @names << "Batting Tendency Infield Left"
        @syms  << "lif"
        @vals  << doc.css('td#lif').inner_html.strip
        @names << "Batting Tendency Infield Center"
        @syms  << "cif"
        @vals  << doc.css('td#cif').inner_html.strip
        @names << "Batting Tendency Infield Right"
        @syms  << "rif"
        @vals  << doc.css('td#rif').inner_html.strip

        @names << "Batting Tendency Fly Balls Total"
        @syms  << "tfb"
        @vals  << doc.css('td#tfb').inner_html.strip
        @names << "Batting Tendency Fly Balls Left"
        @syms  << "lfb"
        @vals  << doc.css('td#lfb').inner_html.strip
        @names << "Batting Tendency Fly Balls Center"
        @syms  << "cfb"
        @vals  << doc.css('td#cfb').inner_html.strip
        @names << "Batting Tendency Fly Balls Right"
        @syms  << "rfb"
        @vals  << doc.css('td#rfb').inner_html.strip

        @names << "Batting Tendency Line Drives Total"
        @syms  << "tld"
        @vals  << doc.css('td#tld').inner_html.strip
        @names << "Batting Tendency Line Drives Left"
        @syms  << "lld"
        @vals  << doc.css('td#lld').inner_html.strip
        @names << "Batting Tendency Line Drives Center"
        @syms  << "cld"
        @vals  << doc.css('td#cld').inner_html.strip
        @names << "Batting Tendency Line Drives Right"
        @syms  << "rld"
        @vals  << doc.css('td#rld').inner_html.strip

        @names << "Batting Tendency Ground Balls Total"
        @syms  << "tgb"
        @vals  << doc.css('td#tgb').inner_html.strip
        @names << "Batting Tendency Ground Balls Left"
        @syms  << "lgb"
        @vals  << doc.css('td#lgb').inner_html.strip
        @names << "Batting Tendency Ground Balls Center"
        @syms  << "cgb"
        @vals  << doc.css('td#cgb').inner_html.strip
        @names << "Batting Tendency Ground Balls Right"
        @syms  << "rgb"
        @vals  << doc.css('td#rgb').inner_html.strip
    end
end
