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
#files << "gc_stats_spray_chart.rb"


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
#names << "StatsSprayChart"


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
#fmts << "GC_PLAYER_BATTING_SPRAY_URI"


=begin
def get_contents(file, name, fmt)
    temp = file.gsub("gc_", "").gsub(".rb", "")
	result = "\n"
	result << "# add copyright header\n"
	result << "\n"
	result << "require './gc_common'\n"
	result << "require './gc_stats_base'\n"
	result << "\n"
	result << "class %s < StatsBase\n" % name
	result << "\n"
	result << "    def initialize(fteam, team_id, fname, linitial, player_id)\n"
	result << "        @uri_fmt   = %s\n" % fmt
	result << "        @stat_name = \"%s\"\n" % temp
	result << "        super(fteam, team_id, fname, linitial, player_id)\n"
	result << "    end\n"
	result << "\n"
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
=end

# stdout the create lines
puts ""
files.each_with_index do |file, index|
    fmt  = fmts[index].to_s
    name = names[index].to_s
	temp = file.to_s
	temp = temp.gsub("gc_", "").gsub("\.rb", "")
    temp2 = "\"%s\"" % temp
    puts "        @%-25s = StatsBase.new(%34s, %30s, fteam, team_id, fname, linitial, @id)\n" % [temp, fmt, temp2]
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


