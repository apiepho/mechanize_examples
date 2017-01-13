# add copyright header

require 'date'

require './gc_common'
require './gc_inning_half'

class Game
    #attr_accessor :score_us, :score_them

	def initialize(game_json)
		# game data comes from game data json from specific team page (given parameter)
		$total_games += 1

		@json = game_json

		# get game lineups
				
		# get game plays page
		uri = GC_PLAYS_URI % + @json["game_id"]
		puts "getting %s ..." % uri if $options.debug
		$browser.goto(uri)
      
		# get body as a string, waiting for javascript to finish populating
		temp = $browser.html
    	seconds = 0
    	while not temp.include?(" inning_1_half_0 \"") and seconds < 30 do
        	sleep(1)
			seconds += 1
			puts seconds if $options.debug
        	temp = $browser.html
		end

		# parse html with Nokogiri		
		doc = Nokogiri::HTML(temp)
		xml_elements = doc.css('.inning_half')
		xml_elements = xml_elements.reverse

		# build list of inning halfs
		@inning_halfs = []
        xml_elements.each do |xml_element|
			next if not $options.halfs.nil? and @inning_halfs.length >= $options.halfs.to_i
            @inning_halfs << InningHalf.new(xml_element)
        end
    end
    
	def display
=begin
# example game_json, one element from team json data
{"home_won"=>false,
 "away_won"=>true,
 "arrival_ts"=>nil,
 "playstatus"=>"CPT",
 "meta"=>{"offline"=>true},
 "result"=>"L",
 "home"=>true,
 "timezone"=>-7.0,
 "utc_start"=>"2016-03-12T19:00:00",
 "sport"=>"BASEB",
 "team_name"=>"Roosevelt",
 "recap_title"=>
  "Eaton (CO) pulls away late for 12-4 victory over Roosevelt Rough Riders Varsity ",
 "state"=>
  {"status"=>"CPT",
   "inning"=>10,
   "side_readable"=>"Top",
   "away"=>12,
   "x"=>"st",
   "w"=>"v",
   "half"=>0,
   "home"=>4,
   "side"=>0},
 "location"=>"Nelson Field 4",
 "play_time"=>"2016-03-12T12:00:00",
 "type"=>"Exhibition",
 "save_ts"=>1457829771.0,
 "recipients"=>[],
 "wl"=>"0-0-0",
 "other_team_id"=>"56e4c51a57a7013ee2000001",
 "game_id"=>"56e4c51a57a7013ef9000002",
 "uses_halves"=>false,
 "notes"=>"",
 "recapstatus"=>"CPT",
 "stream_id"=>"56e428119ddd0a3f1f000001",
 "minutes_before"=>0,
 "other_team_name"=>"Eaton"}
=end
        at_vs        = (@json["home"] === "home" ? "vs" : "at")
        date         = DateTime.parse(@json["utc_start"])
		win_lose_tie = "win"   if (@json["result"] === "W")
		win_lose_tie = "loss"  if (@json["result"] === "L")
		win_lose_tie = "tie"   if (@json["result"] === "T")
        score_home   = @json["state"]["home"].to_i
        score_away   = @json["state"]["away"].to_i
        @score_us    = (@json["home"] ? score_home : score_away)
        @score_them  = (@json["home"] ? score_away : score_home)

		puts "    %s %s" % [at_vs, @json["other_team_name"]]
		puts "      %s" % date.strftime("%A, %b %d %Y %l:%M %p")
		puts "      game_id:  %s" % @json["game_id"] if $options.debug
		puts "      location: %s" % (@json["location"].nil? ? "-" : @json["location"])
		puts "      us:       %s" % @score_us
		puts "      them:     %s" % @score_them
		puts "      result:   %s" % win_lose_tie
		puts "      recap:    %s" % @json["recap_title"]
		puts "      game details:"
		@inning_halfs.each do |inning_half|
			inning_half.display
		end
	end
end

