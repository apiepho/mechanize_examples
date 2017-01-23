# add copyright header

require 'date'

require './gc_common'
require './gc_innings'
require './gc_boxscore'

class Game
    def initialize(game_json)
        # game data comes from game data json from specific team page (given parameter)
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
        $total_games += 1

        @at_vs           = (game_json["home"] === "home" ? "vs" : "at")
        @date            = DateTime.parse(game_json["utc_start"])
        @win_lose_tie    = "win"   if (game_json["result"] === "W")
        @win_lose_tie    = "loss"  if (game_json["result"] === "L")
        @win_lose_tie    = "tie"   if (game_json["result"] === "T")
        score_home       =  game_json["state"]["home"].to_i
        score_away       =  game_json["state"]["away"].to_i
        @score_us        = (game_json["home"] ? score_home : score_away)
        @score_them      = (game_json["home"] ? score_away : score_home)
        @other_team_name =  game_json["other_team_name"]
        @id              =  game_json["game_id"]
        @location        = (game_json["location"].nil? ? "-" : game_json["location"])
        @recap           =  game_json["recap_title"]
        puts @recap if $options.debug

        # get game plays page
        uri = GC_PLAYS_URI % @id
        $browser.goto(uri)

        # get body as a string, waiting for javascript to finish populating
        temp = $browser.html
        seconds = 0
        while not temp.include?("TOP 1ST") and seconds < 30 do
            sleep(1)
            seconds += 1
            puts "." if $options.debug
            temp = $browser.html(true)
        end
        puts "WARNING: page time out on: %s" % uri if seconds > 30

        # parse html with Nokogiri
        doc = Nokogiri::HTML(temp)
        xml_elements       = doc.css('tr')
        xml_elements       = xml_elements.reverse

        # the reverse order isn't quite right, need each inning before plays for that inning
        xml_elements_max   = xml_elements.length - 1
        xml_elements_array = []
        need_inning        = true
        (0..xml_elements_max).each do |index1|
            element1 = xml_elements[index1]
            is_play_row = (element1.attribute('class').to_s.include?('sabertooth_pbp_row') ? true : false)
            if is_play_row
                if need_inning
                    # spin forward to find next inning
                    (index1..xml_elements_max).each do |index2|
                        element2 = xml_elements[index2]
                        is_inning_row = (element2.attribute('class').to_s.include?('sabertooth_pbp_inning_row') ? true : false)                        
                        if is_inning_row
                            xml_elements_array << element2
                            break
                        end
                    end
                    need_inning = false
                end
                xml_elements_array << element1 
            end
            need_inning = true if element1.attribute('class').to_s.include?('sabertooth_pbp_inning_row')
       end

        # build list of inning halfs
        @innings = Innings.new(xml_elements_array)
        
        # get game boxscore (including lineups)
        @boxscore = Boxscore.new(@id)


    end

    def display_xml
        puts "<game>"
        puts "<other_team_name>%s</other_team_name>" % @other_team_name
        puts "<date>%s</date>"                       % @date.strftime("%A, %b %d %Y %l:%M %p")
        puts "<id>%s</id>"                           % @id
        puts "<location>%s</location>"               % @location
        puts "<us>%s</us>"                           % @score_us
        puts "<them>%s</them>"                       % @score_them
        puts "<win_lose_tie>%s</win_lose_tie>"       % @win_lose_tie
        @boxscore.display_xml
        @innings.display_xml
        puts "</game>"
    end
end

