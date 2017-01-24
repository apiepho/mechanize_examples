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
	
    def get_players(given_team_id, membership_json)
        result = []
        membership_json.each do |player_id, team_id|
        	result << get_player(player_id) if team_id === given_team_id
        end
        result
    end

	def get_roster(roster_json)
		result = []
		roster_json.each do |player|
			result << RosterName.new(player)
		end
		result
	end

	def get_pitching_lineup(lineup_json)
		result = []
        lineup_json.each_with_index do |player_id, index|
            players = []
            players << get_player(player_id)
        	result << LineupSlot.new(index+1, players)
        end
        result
	end

	def get_batting_lineup(lineup_json)
		result = []
        lineup_json.each_with_index do |player_ids, index|
            players = []
            player_ids.each do |player_id|
            	players << get_player(player_id)
            end  
        	result << LineupSlot.new(index+1, players)
        end
        result
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
 
        @awayPlayers        = get_players(        json["sabertooth_transcoder_config"]["awayTeamId"],
                                                  json["sabertooth_transcoder_config"]["playerTeamMembership"])
		@awayRoster         = get_roster(         json["game"]["away"]["roster"])
		@awayLineupPitching = get_pitching_lineup(json["game"]["best_account"]["state"]["lineups"]["away"]["pitching"])
		@awayLineupBatting  = get_batting_lineup( json["game"]["best_account"]["state"]["lineups"]["away"]["batting"])

        @homePlayers        = get_players(        json["sabertooth_transcoder_config"]["homeTeamId"],
                                                  json["sabertooth_transcoder_config"]["playerTeamMembership"])
		@homeRoster         = get_roster(         json["game"]["home"]["roster"])
		@homeLineupPitching = get_pitching_lineup(json["game"]["best_account"]["state"]["lineups"]["home"]["pitching"])
		@homeLineupBatting  = get_batting_lineup( json["game"]["best_account"]["state"]["lineups"]["home"]["batting"])
    end

	def display_players(label, players)
        puts "<%s>" % label
        players.each do |player|
        	player.display
        end
        puts "</%s>" % label
	end

    def display_xml
        puts "<boxscore>"
        display_players("all_players", @allPlayers)
        puts "<away_team>"
        display_players("players",         @awayPlayers)
        display_players("roster",          @awayRoster)
        display_players("lineup_pitching", @awayLineupPitching)
        display_players("lineup_batting",  @awayLineupBatting)
        puts "</away_team>"
        puts "<home_team>"
        display_players("players",         @homePlayers)
        display_players("roster",          @homeRoster)
        display_players("lineup_pitching", @homeLineupPitching)
        display_players("lineup_batting",  @homeLineupBatting)
        puts "</home_team>"
        puts "</boxscore>"
    end
end
