# add copyright header

require './gc_common'

class Player

	def initialize(player_json)
		# player data comes from roster data json from specific team page (given parameter)
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
		$total_players += 1

		@name   = player_json["formatted_name"]
		@id     = player_json["player_id"]
		@number = (player_json["num"].nil? ? "-" : player_json["num"])
		@throws = (player_json["t"].nil?   ? "-" : player_json["t"])
		@bats   = (player_json["b"].nil?   ? "-" : player_json["b"])
		@positions = ""
		if not player_json["pos"].empty?
			player_json["pos"].each do |pos|
				@positions += pos
				@positions += " "
			end
		end
	end
    
	def display
		puts "%s%s"   % [ $indent.str, @name ]
		puts "%s%s%s" % [ $indent.str, "player_id:   ", @id        ] if $options.debug
		puts "%s%s%s" % [ $indent.str, "number:      ", @number    ]
		puts "%s%s%s" % [ $indent.str, "throws:      ", @throws    ]
		puts "%s%s%s" % [ $indent.str, "bats:        ", @bats      ]
		puts "%s%s%s" % [ $indent.str, "position(s): ", @positions ]
	end

	def display_xml
		puts "<player>"
		puts "<name>%s</name>"           % @name
		puts "<id>%s</id>"               % @id
		puts "<number>%s</number>"       % @number
		puts "<throws>%s</throws>"       % @throws
		puts "<bats>%s</bats>"           % @bats
		puts "<positions>%s</positions>" % @positions
		puts "</player>"
	end
end

