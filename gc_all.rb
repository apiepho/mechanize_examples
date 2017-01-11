# TODO: add copyright header

require './gc_common'
require './gc_teams'


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

# build teams
teams = Teams.new(browser, options)
teams.dump()
