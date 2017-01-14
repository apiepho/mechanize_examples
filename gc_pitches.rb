# add copyright header

require './gc_common'
require './gc_pitch'

class Pitches
    attr_reader :score_away, :score_home

	def initialize(pitches_xml_element)
		@pitches = []
        pitches_xml_element.each do |xml_element|
			next if not $options.pitches.nil? and @pitches.length >= $options.pitches.to_i
            @pitches << Pitch.new(xml_element)
        end
        @pitches = @pitches.reverse
	end
    
	def display
		puts "%s%s" % [ $indent.str, "pitches:" ]
        $indent.increase
		@pitches.each do |pitch|
			pitch.display
		end
        $indent.decrease
		puts "%s%s%d"      % [ $indent.str, "pitches total: ", @pitches.length ]
	end

	def display_xml
		puts "<pitches>"
		@pitches.each do |pitch|
			pitch.display_xml
		end
		puts "<total>%d</total>"      % @pitches.length
		puts "</pitches>"
	end

end

