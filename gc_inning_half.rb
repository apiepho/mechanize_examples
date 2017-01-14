# add copyright header

require './gc_common'
require './gc_appearences'

class InningHalf

    def initialize(inning_half_xml_element)
=begin
<tbody class="inning_half play_entry inning_5_half_1 ">
<tr class="plateAppearanceRow bbm">...</tr>
...
</tbody>
=end
        @inning_half_str = inning_half_xml_element.values.join(" ").split(" ").join(", ")

        # parse inning_half_xml_element with Nokogiri
        #doc = Nokogiri::HTML(temp)
        xml_elements = inning_half_xml_element.css('.plateAppearanceRow')
        xml_elements = xml_elements.reverse

        # build list of plate appearences
        @appearences = Appearences.new(xml_elements)
    end

    def display
        puts "%s%s" % [ $indent.str, @inning_half_str ]
        @appearences.display
    end

    def display_xml
        puts "<inning_half>"
        puts "<description>%s</description>" % @inning_half_str
        @appearences.display_xml
        puts "</inning_half>"
    end


end

