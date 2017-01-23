# add copyright header

require 'date'

require './gc_common'
require './gc_innings'

class PlayerName
	attr_accessor :id, :lname, :num, :fname
    def initialize(player)
    	@id    = player[0]
    	@lname = player[1]["lastName"]
    	@num   = player[1]["number"]
    	@fname = player[1]["firstName"]
    end
end

class Recap

	def get_name(id)
		name = ""
		found = false
		@playerNames.each do |player|
			if id == player.id
				name = player.lname
				found = true
				break
			end
		end
		name
	end
	
    def initialize(game_id)
        # from game recap page, parse json to get lineups (not shown in html)
        uri = GC_RECAP_URI % [ GC_BASE_URI, game_id ]
        $browser.goto(uri)
        json = $gc_parse.decode($browser.html) 
  
        context = json["sabertooth_game_context"]
        @playerNames = []
        playerNames = context["playerNames"]
        playerNames.each do |player|
        	@playerNames << PlayerName.new(player)
        end
      
        config = json["sabertooth_transcoder_config"]
        @awayTeamId = config["awayTeamId"]
        @homeTeamId = config["homeTeamId"]
        @awayTeam = []
        @homeTeam = []
        playerTeamMembership = config["playerTeamMembership"]
        playerTeamMembership.each do |player_id, team_id|
        	@awayTeam << player_id if team_id === @awayTeamId
        	@homeTeam << player_id if team_id === @homeTeamId
        end
        
        puts "away"
        @awayTeam.each do |player_id|
        	puts "%s   %s" % [ player_id, get_name(player_id) ]
        end
        puts "home"
        @homeTeam.each do |player_id|
        	puts "%s   %s" % [ player_id, get_name(player_id) ]
        end

        lineups_home = json["game"]["best_account"]["state"]["lineups"]["home"]
        lineups_away = json["game"]["best_account"]["state"]["lineups"]["away"]
        
		puts ""       
        puts "away pitching:"
		lineups_away["pitching"].each do |player_id|
        	puts "%s   %s" % [ player_id, get_name(player_id) ]
		end
		puts ""       
        puts "away batting:"
		lineups_away["batting"].each_with_index do |slot, index|
		    puts "slot %d" % (index + 1)
			slot.each do |player_id|
				puts "  %s   %s" % [ player_id, get_name(player_id) ]
			end
		end
		
		puts ""       
        puts "home pitching:"
		lineups_home["batting"].each do |player_id|
        	puts "%s   %s" % [ player_id, get_name(player_id) ]
		end
		puts ""       
        puts "home batting:"
		lineups_home["batting"].each_with_index do |slot, index|
		    puts "slot %d" % (index + 1)
			slot.each do |player_id|
				puts "  %s   %s" % [ player_id, get_name(player_id) ]
			end
		end


		exit
=begin
   "best_account"=>
    {"status"=>"CPT",
     "save_ts"=>1457829771.0,
     "account_id"=>"56e428119ddd0a3f1f000001",
     "state"=>
      {"count"=>{"outs"=>0, "strikes"=>0, "balls"=>0},
       "inning"=>10,
       "lineups"=>
        {"home"=>
          {"pitching"=>
            ["56e4392543ee3f00211cb671",
             "56e4392543ee3f00211cb66d",
             "56e4392543ee3f00211cb673",
             "56e4392543ee3f00211cb674",
             "56e4392543ee3f00211cb66e",
             "56e4392543ee3f00211cb670"],
           "batting"=>
            [["56e4392543ee3f00211cb674"],
             ["56e4392543ee3f00211cb66f", "56e4392543ee3f00211cb66c"],
             ["56e4392543ee3f00211cb672", "56e4392543ee3f00211cb66f"],
             ["56e4392643ee3f00211cb679", "56e4392543ee3f00211cb672"],
             ["56e4392543ee3f00211cb671",
              "56e4392643ee3f00211cb67a",
              "56e4392643ee3f00211cb679"],
             ["56e4392543ee3f00211cb677", "56e4392643ee3f00211cb67a"],
             ["56e4392643ee3f00211cb678"],
             ["56e4392543ee3f00211cb670"],
             ["56e4392543ee3f00211cb66c", "56e4392643ee3f00211cb67c"],
             ["56e4392543ee3f00211cb66e", "56e4392543ee3f00211cb671"],
             ["56e4392543ee3f00211cb675"],
             ["56e4392543ee3f00211cb676"]]},
         "away"=>
          {"pitching"=>["56e428119d9d006490000040"],
           "batting"=>
            [["56e428119d9d006490000037"],
             ["56e428119d9d00649000003a"],
             ["56e428119d9d00649000003d"],
             ["56e428119d9d006490000040"],
             ["56e428119d9d006490000043"],
             ["56e428119d9d006490000046"],
             ["56e428119d9d006490000049"],
             ["56e428119d9d00649000004c"],
             ["56e428119d9d00649000004f"]]}},
=end        
    end

    def display_xml
        puts "<recap>"
=begin
        puts "<other_team_name>%s</other_team_name>" % @other_team_name
        puts "<date>%s</date>"                       % @date.strftime("%A, %b %d %Y %l:%M %p")
        puts "<id>%s</id>"                           % @id
        puts "<location>%s</location>"               % @location
        puts "<us>%s</us>"                           % @score_us
        puts "<them>%s</them>"                       % @score_them
        puts "<win_lose_tie>%s</win_lose_tie>"       % @win_lose_tie
        puts "<recap>%s</recap>"                     % @recap
        @innings.display_xml
=end
        puts "</recap>"
    end
end

