# add copyright header

require 'date'

require './gc_common'
require './gc_inning_half'

class Innings
	def initialize(innings_xml_elements)
		# build list of inning halfs
		@inning_halfs = []
        innings_xml_elements.each do |xml_element|
			next if not $options.halfs.nil? and @inning_halfs.length >= $options.halfs.to_i
            @inning_halfs << InningHalf.new(xml_element)
        end
    end
    
	def display
		puts "%s%s"      % [ $indent.str, "game details:" ]
        $indent.increase
		@inning_halfs.each do |inning_half|
			inning_half.display
		end
        $indent.decrease
	end
end

