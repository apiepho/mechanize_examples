require './gc_common'
require './gc_team'

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

def dump_teams(teams)
	teams.each do |team|
		team.display
	end
	puts $total_teams
	puts $total_games
end


# parse command line options
options = OpenStruct.new
parser = OptionParser.new do |opt|
	opt.on('-e', '--email    <email>',                   '(required) login email for GameChanger')                         { |o| options.email    = o    }
	opt.on('-p', '--password <password>',                '(required) login password for GameChanger')                      { |o| options.password = o    }
	opt.on('-l', '--list',                               '(optional) list team urls')                                      { |o| options.list     = true }
	opt.on('-y', '--year <YYYY>',                        '(optional) specific year')                                       { |o| options.year     = o    }
	opt.on('-s', '--season <spring|summer|fall|winter>', '(optional) specfic season')                                      { |o| options.season   = o    }
	opt.on('-t', '--teams <teams>',                      '(optional) list of sub strings to limit teams (separated by ,)') { |o| options.teams    = o    }
	opt.on('-g', '--games <games>',                      '(debug)    limit games')                                         { |o| options.games    = o    }
	opt.on('-d', '--debug',                              '(debug)    show debug messages')                                 { |o| options.debug    = true }
end
parser.parse!

if options.email.nil? or options.password.nil?
	puts "Error: must provide email and password."
	puts parser.help
	exit
end

# get a new instance of Watir class (NOTE: need chromedriver in path, 
# get chromedriver from https://sites.google.com/a/chromium.org/chromedriver/downloads)
browser = Watir::Browser.new

# login
browser.goto(GC_LOGIN_URI)
puts "getting %s ..." % GC_LOGIN_URI if options.debug
browser.text_field(:id,'email').set(options.email)
browser.text_field(:id,'login_password').set(options.password)
browser.form(:id,'frm_login').submit

# go to teams page
browser.goto(GC_TEAMS_URI)
puts "getting %s ..." % GC_TEAMS_URI if options.debug

# team links have href that includes /t/
team_links = []
browser.links.to_a.each do |link|
	team_links << link.href if link.href.to_s.include?('/t/')
end
team_links = team_links.uniq

teams = []
team_links.each do |link|
	next if not supported_team(options.year, options.season, options.teams, link)
	if options.list
		puts link
	else
		team = Team.new(browser, options, link)
		teams << team
   end
end

dump_teams(teams) if not options.list

