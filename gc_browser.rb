# add copyright header

require 'fileutils'
require 'nokogiri'
require 'watir'

# browser wrapper for cache support
class Browser
    def initialize
        @page_count = 0

        if not $options.cache.nil?
            #FileUtils.rm_rf($options.dest)
            FileUtils.mkdir_p($options.cache)
        end

        if $options.offline.nil?
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

	def build_cache_filename(uri)
        temp = uri.gsub($options.src, "")
        temp = temp[1..-1]
        temp = temp.gsub("/", "_")
        temp = temp.gsub("?", "_")
        temp = temp.gsub("=", "_")
        temp = temp.gsub("&", "_")
        @cache_filename = "%s/%s.html" % [ $options.cache, temp ]
 	end
	
    def goto(uri)
        puts "getting %s ..." % uri if $options.debug

        @page_count += 1
        puts "GC.start, page_count: %d" % @page_count if (@page_count % 10) == 0 and $options.debug
        GC.start                                      if (@page_count % 10) == 0

        build_cache_filename(uri)

        result = nil
        # test cache read
        if not $options.cache.nil?
            if File.file?(@cache_filename)
                 puts "read cache: %s" % @cache_filename  if $options.debug
                 result = true
            end
        end

        # goto web if not cached and not offline
        if result.nil? and $options.offline.nil?
             puts "browser_private.goto"                  if $options.debug
             $browser_private.goto(uri)
        end
    end

    def html(cache_off = false)
        result = nil
        cache_off = true if not $options.wrtcache.nil?
        # test cache read
        if not $options.cache.nil? and not cache_off
            if File.file?(@cache_filename)
                 puts "read cache: %s" % @cache_filename  if $options.debug
                 result = File.read(@cache_filename)
            end
        end

        # get from web if not cached and not offline
        if result.nil? and $options.offline.nil?
             puts "browser_private.html"                  if $options.debug
            result = $browser_private.html
        end

        # test cache write
        if not $options.cache.nil?
            if not File.file?(@cache_filename) and not result.empty?
                 puts "write cache: %s" % @cache_filename if $options.debug
                 File.write(@cache_filename, result)
            end
            if cache_off and not result.empty?
                 puts "force write cache: %s" % @cache_filename if $options.debug
                 File.write(@cache_filename, result)
            end
        end
        result
    end
end

