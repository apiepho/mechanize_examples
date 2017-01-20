# add copyright header

require './gc_common'
require './gc_appearence'

class Appearences

    def initialize(play_xml_elements)
        @appearences = []

        # skip first (inning half) and build appearence for each play row
        xml_elements_max   = play_xml_elements.length - 1
        (1..xml_elements_max).each do |index|
            element = play_xml_elements[index]
            @appearences << Appearence.new(element)
       end
    end

    def display_xml
        puts "<appearences>"
        @appearences.each do |appearence|
            appearence.display_xml
        end
        puts "</appearences>"
    end


end

