# add copyright header

require './gc_common'
require './gc_teams'

# Goals of gc_app
#  parse all GC teams and
#   1) list games in oldest-first (rather than newest-first) order
#   2) Calculate specific player stats


# TODO: Summary list of TODO items
# - finish spray chart stats
# - consolidate stats
# - how to handle cache of stat pages mid season, as games are added?
# - parse lines-ups from game data as gc_lineups.rb
# - add input from xml to speed stats generation work
# - how to get formulas for all 148+ 20 for spray chart?
# - start generation of stats
# - compare generated stats with GC stats
# - merge duplicate players in roster.rb

# - add copyright to header of all files
# - add setup of ruby enviroment
# - add good readme (think about adding to linked in)
# - new repo for gc_app


# General structure:
# (all files require gc_common)
# common
#   browser
#   indent

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
#
#   event (pitch, event)
#   href
#   play++
#   recap (ie. ball, strike, play.recap)

# play
#   defense touches
#     touch++
#   offense touches
#     touch++
#   recap

# touch
#  name
#  player href
#  number
#  position (Pitcher etc, Batter, Scorer)


def display_xml(teams)
    puts "<gc>"
    teams.display_xml()
    puts "</gc>"
end

# parse command line options
$options = OpenStruct.new
parser = OptionParser.new do |opt|
    opt.on('-i', '--input <web|xml>',                      'input type: web, or xml file (default: web)')                    { |o| $options.input        = o    }
    opt.on('-s', '--src <url|dir|xmlfile>',                'web url, dir name, or xml file (default gc.com)')                { |o| $options.src          = o    }
    opt.on('-o', '--output <stdout|xml>',                  'output type: stdout, or xml file (default: stdout)')             { |o| $options.output       = o    }
    opt.on('-d', '--dest <stdout|xmlfile>',                'stdout, or xml file (default: stdout)')                          { |o| $options.dest         = o    }
    opt.on('-e', '--email <email>',                        'login email for GameChanger')                                    { |o| $options.email        = o    }
    opt.on('-p', '--password <password>',                  'login password for GameChanger')                                 { |o| $options.password     = o    }
    opt.on('-c', '--cache <dir>',                          '(optional) enable auto-cache of web pages')                      { |o| $options.cache        = o    }
    opt.on('-f', '--offline',                              '(optional) run offline')                                         { |o| $options.offline      = true }
    opt.on('-l', '--list',                                 '(optional) list team urls')                                      { |o| $options.list         = true }
    opt.on('-Y', '--year <YYYY>',                          '(optional) specific year')                                       { |o| $options.year         = o    }
    opt.on('-S', '--season <spring|summer|fall|winter>',   '(optional) specfic season')                                      { |o| $options.season       = o    }
    opt.on('-T', '--teams <teams>',                        '(optional) list of sub strings to limit teams (separated by ,)') { |o| $options.teams        = o    }
    opt.on('-R', '--Roster <count>',                       '(debug)    limit roster per team')                               { |o| $options.roster       = o    }
    opt.on('-G', '--Games <count>',                        '(debug)    limit games per team')                                { |o| $options.games        = o    }
    opt.on('-I', '--Innings <count>',                      '(debug)    limit inning halfs per game')                         { |o| $options.halfs        = o    }
    opt.on('-A', '--Appearences <count>',                  '(debug)    limit plate appearences per game')                    { |o| $options.appearences  = o    }
    opt.on('-P', '--Pitches <count>',                      '(debug)    limit pitches per plate appearences')                 { |o| $options.pitches      = o    }
    opt.on('-D', '--Debug',                                '(debug)    show debug messages')                                 { |o| $options.debug        = true }
end
parser.parse!

# validate options
if $options.input.nil?
    $options.input = "web"
    $options.src   = GC_BASE_URI
end
if ["web"].include?($options.input) and $options.src.nil?
    $options.src   = GC_BASE_URI
end
if $options.output.nil?
    $options.output = "stdout"
    $options.dest   = nil
end
if ["xml"].include?($options.output)
    $options.xml  = true
    $options.file = $options.dest
end

if not ["web", "xml"].include?($options.input)
    puts "Error: must provide input value."
    puts parser.help
    exit
end
if ["web"].include?($options.input)
    if $options.email.nil? or $options.password.nil?
        puts "Error: must provide email and password."
        puts parser.help
        exit
    end
end
if not ["stdout", "xml"].include?($options.output)
    puts "Error: must provide output value."
    puts parser.help
    exit
end
if ["xml"].include?($options.output)
    if $options.dest.nil?
        puts "Error: must provide dest value."
        puts parser.help
        exit
    end
end
if not $options.cache.nil?
    if not $options.cache.start_with?("/") and not $options.cache.start_with?("./")
        puts "Error: cache must be full path or relative (start with / or ./ ."
        puts parser.help
        exit
    end
end

$browser = Browser.new
=begin
# get a new instance of Watir class (NOTE: need chromedriver in path,
# get chromedriver from https://sites.google.com/a/chromium.org/chromedriver/downloads)
$browser = Watir::Browser.new(:chrome)
$browser.window.resize_to(1200, 1000)
#$browser.window.move_to(100, 100)
=end


# build teams
teams = Teams.new()

if not $options.output === "cache"
    # start redirect to file (easiest way to save to a xml file)
    old_stdout = $stdout
    $stdout = File.open($options.file, "w") if not $options.file.nil?

    display_xml(teams) if $options.xml

    # restore stdout
    $stdout = old_stdout
end
