# add copyright header

require './gc_common'
require './gc_game'

class Games

	def initialize(games_json_decoded)
		# from json game summary,  build list of Games
		@games = []
		games_json_decoded.each do |game_json|
			next if not supported_game(game_json)
			@games << Game.new(game_json)
		end 
	end
   
	def supported_game(game_json)
		result = true
     	result = false if not $options.games.nil? and @games.length >= $options.games.to_i
        result = false if game_json.nil? or game_json["game_id"].nil?
        result
	end

	def display
		puts "%s%s"        % [ $indent.str, "games:" ]
        $indent.increase
		@games.each do |game|
			game.display
		end
        $indent.decrease
	end
end
