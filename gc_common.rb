# add copyright header

require 'fileutils'
require 'json'
require 'nokogiri'
require 'optparse'
require 'ostruct'
require 'pp'
require 'watir'


GC_BASE_URI  = 'https://gc.com'
GC_LOGIN_URI = GC_BASE_URI + '/login'
GC_ROSTER_URI = "%s/roster"           # given team guid
GC_PLAYER_URI = "%s/p/%s"             # given team guid and player fname-lastinitial-guid
#GC_TEAMS_URI = GC_BASE_URI + '/teams?page_number=0&page_size=1000'
# NOTE: since we are parsing json instead of html, don't need to set page_size
GC_TEAMS_URI = GC_BASE_URI + '/teams'
GC_PLAYS_URI = GC_BASE_URI + "/game-%s/plays"

$options = nil
$browser = nil

# debug/status
$total_teams = 0
$total_players = 0
$total_games = 0

# indent control
class Indent
    attr_reader :str

    def initialize
        @str = ""
        puts "==%d" % @str.length if $options.debug
    end

    def increase
        @str = "  " + @str
        puts "++%d" % @str.length if $options.debug
    end

    def decrease
        @str = @str[2..-1] if not @str.empty?
        puts "--%d" % @str.length if $options.debug
    end
end
$indent = nil

# browser wrapper for cache support
class Browser

    attr_reader :page_count
    
    def initialize
        @page_count = 0
        
        if $options.output === "cache"
            FileUtils.rm_rf($options.dest)
            FileUtils.mkdir_p($options.dest)
        end
        
        if not $options.input === "cache"
            # get a new instance of Watir class (NOTE: need chromedriver in path,
            # get chromedriver from https://sites.google.com/a/chromium.org/chromedriver/downloads)
            $browser_private = Watir::Browser.new(:chrome)
            $browser_private.window.resize_to(1200, 1000)
            #$browser_private.window.move_to(100, 100)

            # login
            $browser_private.goto(GC_LOGIN_URI)
            puts "getting %s ..." % GC_LOGIN_URI if $options.debug
            $browser_private.text_field(:id,'email').set($options.email)
            $browser_private.text_field(:id,'login_password').set($options.password)
            $browser_private.form(:id,'frm_login').submit
        end
    end

    def goto(uri)
        @page_count += 1
        puts "GC.start" if (@page_count % 10) == 0 and $options.debug
        GC.start if (@page_count % 10) == 0

        if $options.output === "cache"
            temp = uri.gsub($options.src, "")
            temp = temp[1..-1]
            temp = temp.gsub("/", "_")
            @cache_path = "%s/%s" % [ $options.dest, temp ]
        end
        $browser_private.goto(uri)
    end

    def html
        result = $browser_private.html
        if $options.output === "cache"
            File.write(@cache_path, result)
        end
        result
    end

    def links
        result = $browser_private.links
        result
    end
end
$browser_private = nil

