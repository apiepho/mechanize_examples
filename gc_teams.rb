# TODO: add copyright header


require './gc_common'
require './gc_team'

class Teams
	def initialize(browser, options)
		# teams data can be found in the teams page

		# go to teams page
		browser.goto(GC_TEAMS_URI)
		puts "getting %s ..." % GC_TEAMS_URI if options.debug

		# team links have href that includes /t/
		links = []
		browser.links.to_a.each do |link|
			links << link.href if link.href.to_s.include?('/t/')
		end
		links = links.uniq

		@teams = []
		links.each do |link|
			next if not supported_team(options.year, options.season, options.teams, link)
			if options.list
				puts link
			else
				team = Team.new(browser, options, link)
				@teams << team
			end
		end
	end

	def supported_team(year, season, teams, href)
		result = true
		if result and not year.nil?
			result = false
			result = true if href.include?(year + "/")
		end
		if result and not season.nil?
			result = false
			result = true if href.include?("/" + season.downcase)
		end
		if result and not teams.nil?
			result = false
			parts = teams.split(",")
			parts.each do |part|
				result = true if href.include?("/" + part.strip)
			end
		end
		result
	end

	def dump()
		@teams.each do |team|
			team.display
		end
		puts $total_teams
		puts $total_games
	end
end
