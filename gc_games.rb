# add copyright header

require './gc_common'
require './gc_game'

class Games

    def initialize(games_json)
        # from json game summary,  build list of Games
        @games = []
        games_json.each do |game_json|
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

    def display_xml
        puts "<games>"
        @games.each do |game|
            game.display_xml
        end
        puts "</games>"
    end
end

