# add copyright header

require './gc_common'
require './gc_pitches'

class Appearence
    attr_reader :score_away, :score_home

	def initialize(plate_appearence_xml_element)
		@xml_element = plate_appearence_xml_element
		
		# parse plate_appearence_xml_element with Nokogiri		
		#doc = Nokogiri::HTML(temp)
		xml_elements = @xml_element.css('.gs_pitch_li')
		xml_elements = xml_elements.reverse

		# build list of pitches
		@pitches = Pitches.new(xml_elements)

        # parse running score
		xml_elements = @xml_element.css('.scoreColumn')
        @score_away = xml_elements[0].inner_text.to_i
        @score_home = xml_elements[1].inner_text.to_i
	end
    
	def display
		@pitches.display
		puts "%s%s%2d %2d" % [ $indent.str, "running score: ", @score_away, @score_home ]
	end
end

