# add copyright header

require './gc_common'
require './gc_teams'

# Goals of gc_app
#  parse all GC teams and
#   1) list games in oldest-first (rather than newest-firs) order
#   2) Caclulate specfiic player stats


# TODO: Summary list of TODO items
# - refactor any saved json/xml as specific class members (player, game)
# - display as xml option
# - save to file option
# - restore from file option

# - parse pitches including type (pitch, event-lineup, event-walk, event-out + play, event-scored + play, event + play)
# - parse/add play with reference to players involved, display play short cut ie. 6-4-3
# - parse plate appearences and plays
# - parse lines-ups from game data as gc_lineups.rb
# - parse GC stats if available
# - start generation of stats
# - compare generated stats with GC stats
# - merge duplicate players in roster.rb

# - add copyright to header of all files

# General structure:
# app
#   teams
#     teams++

# team
#   id
#   name
#   location
#   record
#   other?
#   roster
#     player++
#   games
#     game++

#  player
#   id
#   name
#   number
#   positions
#   other?
#   stats_given++ (TODO)
  
# game
#   id
#   opponent_id
#   opponent_name
#   location
#   home_away
#   score_home
#   score_away
#   win_lose_tie
#   other?
#   innings
#     inning_half++

# inning_half
#   description
#   apperences
#     apperence++

# appearance
#   score_away
#   score_home
#   pitches
#     pitch++

# pitch
#   description
#   type (pitch, event, event out, event scored, event lineup) (TODO)
#   play++                                                     (TODO)


# parse command line options
$options = OpenStruct.new
parser = OptionParser.new do |opt|
	opt.on('-e', '--email    <email>',                   'login email for GameChanger')                                    { |o| $options.email        = o    }
	opt.on('-p', '--password <password>',                'login password for GameChanger')                                 { |o| $options.password     = o    }
	opt.on('-l', '--list',                               '(optional) list team urls')                                      { |o| $options.list         = true }
	opt.on('-y', '--year <YYYY>',                        '(optional) specific year')                                       { |o| $options.year         = o    }
	opt.on('-s', '--season <spring|summer|fall|winter>', '(optional) specfic season')                                      { |o| $options.season       = o    }
	opt.on('-t', '--teams <teams>',                      '(optional) list of sub strings to limit teams (separated by ,)') { |o| $options.teams        = o    }
	opt.on('-R', '--Roster <count>',                     '(debug)    limit roster per team')                               { |o| $options.roster       = o    }
	opt.on('-G', '--Games <count>',                      '(debug)    limit games per team')                                { |o| $options.games        = o    }
	opt.on('-I', '--Innings <count>',                    '(debug)    limit inning halfs per game')                         { |o| $options.halfs        = o    }
	opt.on('-A', '--Appearences <count>',                '(debug)    limit plate appearences per game')                    { |o| $options.appearences  = o    }
	opt.on('-P', '--Pitches <count>',                    '(debug)    limit pitches per plate appearences')                 { |o| $options.pitches      = o    }
	opt.on('-D', '--Debug',                              '(debug)    show debug messages')                                 { |o| $options.debug        = true }
end
parser.parse!

if $options.email.nil? or $options.password.nil?
	puts "Error: must provide email and password."
	puts parser.help
	exit
end

# get a new instance of Watir class (NOTE: need chromedriver in path, 
# get chromedriver from https://sites.google.com/a/chromium.org/chromedriver/downloads)
$browser = Watir::Browser.new(:chrome)
$browser.window.resize_to(1200, 1000)
#$browser.window.move_to(100, 100)

# login
$browser.goto(GC_LOGIN_URI)
puts "getting %s ..." % GC_LOGIN_URI if $options.debug
$browser.text_field(:id,'email').set($options.email)
$browser.text_field(:id,'login_password').set($options.password)
$browser.form(:id,'frm_login').submit

# build teams
teams = Teams.new()

puts "Results from parsing..."
$indent = Indent.new
teams.display()
