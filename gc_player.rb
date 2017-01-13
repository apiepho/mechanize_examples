# add copyright header

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
		puts "%s%s"   % [ $indent.str, @json["formatted_name"] ]
		puts "%s%s%s" % [ $indent.str, "player_id:   ", @json["player_id"] ] if $options.debug
		puts "%s%s%s" % [ $indent.str, "number:      ", (@json["num"].nil? ? "-" : @json["num"]) ]
		puts "%s%s%s" % [ $indent.str, "throws:      ", (@json["t"].nil? ? "-" : @json["t"]) ]
		puts "%s%s%s" % [ $indent.str, "bats:        ", (@json["b"].nil? ? "-" : @json["b"]) ]
		pos_str = ""
		if not @json["pos"].empty?
			@json["pos"].each do |pos|
				pos_str += pos
				pos_str += " "
			end
		end
		puts "%s%s%s" % [ $indent.str, "position(s): ", pos_str ]
	end
end

