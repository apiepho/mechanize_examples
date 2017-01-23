# add copyright header

require 'date'

require './gc_common'
require './gc_innings'

class PlayerName
=begin
     "56e4392643ee3f00211cb67c"=>
      {"lastName"=>"Gonzales", "number"=>"3", "firstName"=>"Cam"},
=end
	attr_accessor :id, :lname, :num, :fname
    def initialize(player)
    	@id    = player[0]
    	@lname = player[1]["lastName"]
    	@num   = player[1]["number"]
    	@fname = player[1]["firstName"]
    end
    
    def display
        puts "<player_name>"
        puts "<id>%s</id>>"       % @id
        puts "<fname>%s</fname>>" % @fname
        puts "<lname>%s</lname>>" % @lname
        puts "<num>%s</num>>"     % @num
        puts "</player_name>"
    end
end

class RosterName
=begin
       {"b"=>"R",
        "pos"=>["P"],
        "lname"=>"Sterling",
        "num"=>"2",
        "t"=>"R",
        "fname"=>"TJ",
        "player_id"=>"56e4392543ee3f00211cb66d"},
=end
	attr_accessor :id, :lname, :num, :fname
	def initialize(player)
		@bats      = player["b"]
		@positions = []
		player["pos"].each do |pos|
			@positions << pos
		end
    	@lname     = player["lname"]
    	@num       = player["num"]
		@throws    = player["t"]
    	@fname     = player["fname"]
    	@id        = player["player_id"]
	end

	def display
        puts "<roster_name>"
        puts "<id>%s</id>>"         % @id
        puts "<fname>%s</fname>>"   % @fname
        puts "<lname>%s</lname>>"   % @lname
        puts "<num>%s</num>>"       % @num
        puts "<bats>%s</bats>>"     % @bats
        puts "<throws>%s</throws>>" % @throws
        puts "</roster_name>"
	end
end

class LineupSlot

	def initialize(slot_number, players)
		@slot_number = slot_number
		@players = players
	end
	
	def display
        puts "<slot>"
        puts "<slot_number>%d</slot_number>" % @slot_number
        @players.each do |player|
        	player.display
        end       
        puts "</slot>"
	end
end


class Boxscore
	def get_player(player_id)
		result = nil
		@allPlayers.each do |player|
			if player_id == player.id
				result = player
				break
			end
		end
		result
	end

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
        # from game boxscore page, parse json to get lineups (not shown in html)
        uri = GC_STATS_URI % [ GC_BASE_URI, game_id ]
        $browser.goto(uri)
        json = $gc_parse.decode($browser.html) 
  
  		# get all player names for future descriptions
        @allPlayers = []
        playerNames = json["sabertooth_game_context"]["playerNames"]
        playerNames.each do |player|
        	@allPlayers << PlayerName.new(player)
        end
 
        # get away players (a superset of fielding roster and batting lineup)
        @awayPlayers = []
        awayTeamId = json["sabertooth_transcoder_config"]["awayTeamId"]
        playerTeamMembership = json["sabertooth_transcoder_config"]["playerTeamMembership"]
        playerTeamMembership.each do |player_id, team_id|
        	@awayPlayers << get_player(player_id) if team_id === awayTeamId
        end

		# get away fielding roster
		@awayRoster = []
		roster = json["game"]["away"]["roster"]
		roster.each do |player|
			@awayRoster << RosterName.new(player)
		end
		
		# get away pitching lineup
		@awayLineupPitching = []
        lineup = json["game"]["best_account"]["state"]["lineups"]["away"]["pitching"]
        lineup.each_with_index do |player_id, index|
            players = []
            players << get_player(player_id)
        	@awayLineupPitching << LineupSlot.new(index+1, players)
        end

		# get away batting lineup
		@awayLineupBatting = []
        lineup = json["game"]["best_account"]["state"]["lineups"]["away"]["batting"]
        lineup.each_with_index do |player_ids, index|
            players = []
            player_ids.each do |player_id|
            	players << get_player(player_id)
            end  
        	@awayLineupBatting << LineupSlot.new(index+1, players)
        end

        # get home players (a superset of fielding roster and batting lineup)
        @homePlayers = []
        homeTeamId = json["sabertooth_transcoder_config"]["homeTeamId"]
        playerTeamMembership = json["sabertooth_transcoder_config"]["playerTeamMembership"]
        playerTeamMembership.each do |player_id, team_id|
        	@homePlayers << get_player(player_id) if team_id === homeTeamId
        end

		# get home fielding roster
		@homeRoster = []
		roster = json["game"]["home"]["roster"]
		roster.each do |player|
			@homeRoster << RosterName.new(player)
		end
		
		# get home pitching lineup
		@homeLineupPitching = []
        lineup = json["game"]["best_account"]["state"]["lineups"]["home"]["pitching"]
        lineup.each_with_index do |player_id, index|
            players = []
            players << get_player(player_id)
        	@homeLineupPitching << LineupSlot.new(index+1, players)
        end

		# get away batting lineup
		@homeLineupBatting = []
        lineup = json["game"]["best_account"]["state"]["lineups"]["home"]["batting"]
        lineup.each_with_index do |player_ids, index|
            players = []
            player_ids.each do |player_id|
            	players << get_player(player_id)
            end  
        	@homeLineupBatting << LineupSlot.new(index+1, players)
        end
    end

    def display_xml
        puts "<boxscore>"

        puts "<all_players>"
        @allPlayers.each do |player|
        	player.display
        end
        puts "</all_players>"

        puts "<away_team>"
        puts "<players>"
        @awayPlayers.each do |player|
        	player.display
        end
        puts "</players>"
        puts "<roster>"
        @awayRoster.each do |player|
        	player.display
        end
        puts "</roster>"
        puts "<lineup_pitching>"
        @awayLineupPitching.each do |player|
        	player.display
        end
        puts "</lineup_pitching>"
        puts "<lineup_batting>"
        @awayLineupBatting.each do |player|
        	player.display
        end
        puts "</lineup_batting>"
        puts "</away_team>"

        puts "<home_team>"
        puts "<players>"
        @homePlayers.each do |player|
        	player.display
        end
        puts "</players>"
        puts "<roster>"
        @homeRoster.each do |player|
        	player.display
        end
        puts "</roster>"
        puts "<lineup_pitching>"
        @homeLineupPitching.each do |player|
        	player.display
        end
        puts "</lineup_pitching>"
        puts "<lineup_batting>"
        @homeLineupBatting.each do |player|
        	player.display
        end
        puts "</lineup_batting>"
        puts "</home_team>"

        puts "</boxscore>"
    end
end

