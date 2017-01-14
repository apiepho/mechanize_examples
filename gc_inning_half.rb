# add copyright header

require './gc_common'
require './gc_appearences'

class InningHalf

	def initialize(inning_half_xml_element)
		@xml_element = inning_half_xml_element
		
		# parse inning_half_xml_element with Nokogiri		
		#doc = Nokogiri::HTML(temp)
		xml_elements = @xml_element.css('.plateAppearanceRow')
		xml_elements = xml_elements.reverse

		# build list of plate appearences
		@appearences = Appearences.new(xml_elements)
	end
    
	def display
=begin
<tbody class="inning_half play_entry inning_5_half_1 ">
<tr class="plateAppearanceRow bbm">...</tr>
...
</tbody>
=end
        inning_half_str = @xml_element.values.join(" ").split(" ").join(", ")
		puts "%s%s" % [ $indent.str, inning_half_str ]
		@appearences.display
	end
end

