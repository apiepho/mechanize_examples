# add copyright header

require './gc_common'
require './gc_plate_appearence'

class InningHalf

	def initialize(inning_half_xml_element)
		@xml_element = inning_half_xml_element
		
		# parse inning_half_xml_element with Nokogiri		
		#doc = Nokogiri::HTML(temp)
		xml_elements = @xml_element.css('.plateAppearanceRow')
		xml_elements = xml_elements.reverse

		# build list of inning halfs
		@plate_appearences = []
        xml_elements.each do |xml_element|
			next if not $options.plates.nil? and @plate_appearences.length >= $options.plates.to_i
            @plate_appearences << PlateAppearence.new(xml_element)
        end
	end
    
	def display
=begin
<tbody class="inning_half play_entry inning_5_half_1 ">
<tr class="plateAppearanceRow bbm">...</tr>
...
</tbody>
=end
		puts @xml_element.values
		@plate_appearences.each do |plate_appearence|
			plate_appearence.display
		end
	end
end

