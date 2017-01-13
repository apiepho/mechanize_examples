# add copyright header


require './gc_common'
require './gc_team'

class Teams
	def initialize()
		# teams data can be found in the teams page

		# go to teams page
		$browser.goto(GC_TEAMS_URI)
		puts "getting %s ..." % GC_TEAMS_URI if $options.debug

		# team links have href that includes /t/
		links = []
		$browser.links.to_a.each do |link|
			links << link.href if link.href.to_s.include?('/t/')
		end
		links = links.uniq

		@teams = []
		links.each do |link|
			next if not supported_team(link)
			if $options.list
				puts link
			else
				team = Team.new(link)
				@teams << team
			end
		end
	end

	def supported_team(href)
		result = true
		if result and not $options.year.nil?
			result = false
			result = true if href.include?($options.year + "/")
		end
		if result and not $options.season.nil?
			result = false
			result = true if href.include?("/" + $options.season.downcase)
		end
		if result and not $options.teams.nil?
			result = false
			parts = $options.teams.split(",")
			parts.each do |part|
				result = true if href.include?("/" + part.strip)
			end
		end
		result
	end

	def display()
		@teams.each do |team|
			team.display
		end
		puts $total_teams
		puts $total_players
		puts $total_games
	end
end
