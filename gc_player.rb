# TODO: add copyright header

require './gc_common'

class Player

	def initialize(player_json)
		# player data comes from roster data json from specific team page (given parameter)
		$total_players += 1

		@json = player_json
	end
    
	def display
=begin
# example player_json, one element from team roster json data
   {"b"=>"L",
    "formatted_name_mobile"=>"Andres Garcia",
    "formatted_name"=>"Andres Garcia",
    "pos"=>["P", "1B", "DH"],
    "lname"=>"Garcia",
    "num"=>"6",
    "t"=>"L",
    "fname"=>"Andres",
    "player_id"=>"56e4392543ee3f00211cb670",
    "wall_advice"=>[]},
=end
		puts "    %s" % @json["formatted_name"]
		puts "      player_id:   %s" % @json["player_id"] if $options.debug
		puts "      number:      %s" % (@json["num"].nil? ? "-" : @json["num"])
		puts "      throws:      %s" % (@json["t"].nil? ? "-" : @json["t"])
		puts "      bats:        %s" % (@json["b"].nil? ? "-" : @json["b"])
		pos_str = ""
		if not @json["pos"].empty?
			@json["pos"].each do |pos|
				pos_str += pos
				pos_str += " "
			end
		end
		puts "      position(s): %s" % pos_str
	end
end

