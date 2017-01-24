# add copyright header

require './gc_common'
require './gc_teams'

# Goals of gc_app
#  parse all GC teams and
#   1) list games in oldest-first (rather than newest-first) order
#   2) Calculate specific player stats


# TODO: Summary list of TODO items
# - start generation of some stats (batting: PA, BA, OBP, SLG, field: PO E, catch: INN PB SB SB-ATT CS CS% PIK CI)
# - compare generated stats with GC stats

# - merge duplicate players in roster.rb
# - change cache files to use .html

# - add copyright to header of all files
# - add SETUP.TXT (from history)
# - add README.TXT
# - add private README with references to sites I used???
# - generate Linkedin Blurb
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
#   roster
#     player++
#   games
#     game++

#  player
#   id
#   name
#   number
#   positions
#   stats++

# game
#   id
#   opponent_id
#   opponent_name
#   location
#   home_away
#   score_home
#   score_away
#   win_lose_tie
#   innings
#     inning_half++

# inning_half
#   description
#   apperences
#     apperence++

# appearance
#   result
#   score
#   outs
#   pitch_summary
#   play_description

# stats
#   batting_standard
#   batting_speed
#   batting_team_impact
#   pitching_standard
#   pitching_efficiency
#   pitching_command
#   pitching_batter
#   pitching_runs
#   pitching_pitch
#   fielding_standard
#   fielding_catcher
#   batting_spray_chart

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
    opt.on('-w', '--write cache only',                      '(optional) force writes of cache')                              { |o| $options.wrtcache     = true }
    opt.on('-f', '--offline',                              '(optional) run offline')                                         { |o| $options.offline      = true }
    opt.on('-l', '--list',                                 '(optional) list team urls')                                      { |o| $options.list         = true }
    opt.on('-Y', '--year <YYYY>',                          '(optional) specific year')                                       { |o| $options.year         = o    }
    opt.on('-S', '--season <spring|summer|fall|winter>',   '(optional) specfic season')                                      { |o| $options.season       = o    }
    opt.on('-T', '--teams <teams>',                        '(optional) list of sub strings to limit teams (separated by ,)') { |o| $options.teams        = o    }
    opt.on('-R', '--Roster <count>',                       '(debug)    limit roster per team')                               { |o| $options.roster       = o    }
    opt.on('-G', '--Games <count>',                        '(debug)    limit games per team')                                { |o| $options.games        = o    }
    opt.on('-I', '--Innings <count>',                      '(debug)    limit inning halfs per game')                         { |o| $options.halfs        = o    }
    opt.on('-A', '--Appearences <count>',                  '(debug)    limit plate appearences per game')                    { |o| $options.appearences  = o    }
    opt.on('-D', '--Debug',                                '(debug)    show debug messages')                                 { |o| $options.debug        = true }
    opt.on('-v', '--Version',                              'show the current version of the app.')                           { |o| $options.version      = true }
end
parser.parse!

if $options.version
	puts "gc_app: version %s" % GC_APP_VERSION
	exit
end

# validate options
if $options.input.nil?
    $options.input = "web"
    $options.src   = GC_BASE_URI
end
if ["web"].include?($options.input) and $options.src.nil?
    $options.src   = GC_BASE_URI
end
if ["xml"].include?($options.input)
        puts "Error: Input from xml not yet implemented."
        puts parser.help
        exit
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

$gc_parse = GCParse.new
$browser = Browser.new

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
