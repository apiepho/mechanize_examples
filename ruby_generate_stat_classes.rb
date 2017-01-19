#!/usr/bin/env ruby -i

require 'fileutils'

files = []
files << "gc_stats_batting_standard.rb"
files << "gc_stats_batting_speed.rb"
files << "gc_stats_batting_team_impact.rb"
files << "gc_stats_pitching_standard.rb"
files << "gc_stats_pitching_efficiency.rb"
files << "gc_stats_pitching_command.rb"
files << "gc_stats_pitching_batter.rb"
files << "gc_stats_pitching_runs.rb"
files << "gc_stats_pitching_pitch.rb"
files << "gc_stats_fielding_standard.rb"
files << "gc_stats_fielding_catcher.rb"
files << "gc_stats_spray_chart.rb"


names = []
names << "StatsBattingStandard"
names << "StatsBattingSpeed"
names << "StatsBattingTeamImpact"
names << "StatsPitchingStandard"
names << "StatsPitchingEfficiency"
names << "StatsPitchingCommand"
names << "StatsPitchingBatterResults"
names << "StatsPitchingRuns"
names << "StatsPitchingPitchBreakdown"
names << "StatsFieldingStandard"
names << "StatsFieldingCatching"
names << "StatsSprayChart"


fmts = []
fmts << "GC_PLAYER_BATTING_STANDARD_URI"
fmts << "GC_PLAYER_BATTING_SPEED_URI"
fmts << "GC_PLAYER_BATTING_TEAMIMPACT_URI"
fmts << "GC_PLAYER_PITCHING_STANDARD_URI"
fmts << "GC_PLAYER_PITCHING_EFFICIENCY_URI"
fmts << "GC_PLAYER_PITCHING_COMMAND_URI"
fmts << "GC_PLAYER_PITCHING_BATTER_URI"
fmts << "GC_PLAYER_PITCHING_RUNS_URI"
fmts << "GC_PLAYER_PITCHING_PITCH_URI"
fmts << "GC_PLAYER_FIELDING_STANDARD_URI"
fmts << "GC_PLAYER_FIELDING_CATCHING_URI"
fmts << "GC_PLAYER_BATTING_SPRAY_URI"


def get_contents(file, name, fmt)
    temp = file.gsub("gc_", "").gsub(".rb", "")
	result = "\n"
	result << "# add copyright header\n"
	result << "\n"
	result << "require './gc_common'\n"
	result << "\n"
	result << "class %s\n" % name
	result << "\n"
	result << "    def initialize(fteam, team_id, fname, linitial, player_id)\n"
	result << "        uri = %s %% [GC_BASE_URI, fteam, team_id, fname, linitial, player_id]\n" % fmt
	result << "        $browser.goto(uri)\n"
	result << "        temp = $browser.html\n"
	result << "        doc = Nokogiri::HTML($browser.html)\n"
	result << "        totals = doc.css('totals_all')\n"
	result << "        puts totals if $options.debug\n"
	result << "        @param1 = \"param1\"\n"
	result << "        @param2 = \"param2\"\n"
	result << "        @param3 = \"param3\"\n"
	result << "    end\n"
	result << "\n"
	result << "    def display\n"
	result << "        puts \"%%s%%s\" %% [ $indent.str, \"%s: \"]\n" % temp
	result << "        $indent.increase\n"
	result << "        puts \"%s%s%s\" % [ $indent.str, \"param1: \", @param1 ]\n"
	result << "        puts \"%s%s%s\" % [ $indent.str, \"param2: \", @param2 ]\n"
	result << "        puts \"%s%s%s\" % [ $indent.str, \"param3: \", @param3 ]\n"
	result << "        $indent.decrease\n"

	result << "    end\n"
	result << "\n"
	result << "    def display_xml\n"
	result << "        puts \"<%s\>\"\n" % temp
	result << "        puts \"<param1>\%s</param1>\" \% \@param1\n"
	result << "        puts \"<param2>\%s</param2>\" \% \@param2\n"
	result << "        puts \"<param3>\%s</param3>\" \% \@param3\n"
	result << "        puts \"</%s\>\"\n" % temp
	result << "    end\n"
	result << "end\n"
end

# generate class files
files.each_with_index do |file, index|
    name = names[index].to_s
    fmt  = fmts[index].to_s
	contents = get_contents(file, name, fmt)
	#puts contents
	#puts ""
    File.write(file, contents)	
end

# stdout the requires
puts ""
files.each do |file|
	temp = file.to_s
	temp = temp.gsub("\.rb", "")
    puts "require './%s'\n" % temp
end

# stdout the create lines
puts ""
files.each_with_index do |file, index|
	temp = file.to_s
	temp = temp.gsub("gc_", "").gsub("\.rb", "")
    puts "        @%-25s = %s.new(fteam, team_id, fname, linitial, @id)\n" % [temp, names[index]]
end
        
# stdout the dislay lines
puts ""
files.each do |file|
	temp = file.to_s
	temp = temp.gsub("gc_", "").gsub("\.rb", "")
	puts "        @%s.display\n" % temp
end

# stdout the disaply_xml lines
puts ""
files.each do |file|
	temp = file.to_s
	temp = temp.gsub("gc_", "").gsub("\.rb", "")
	puts "        @%s.display_xml\n" % temp
end


