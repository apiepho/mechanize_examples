# TODO: add copyright header

require './gc_common'

class Roster
	def initialize(browser, options, team_href)
		# roster data can be found in the teams roster page

		# go to team roster page
		uri = GC_ROSTER_URI % team_href
		puts "getting %s ..." % uri if options.debug
		browser.goto(uri)
		
		pp browser.html
		sleep 5

	end


	def dump()
		puts "roster"
	end
end

