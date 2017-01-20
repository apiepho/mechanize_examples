# add copyright header

require './gc_common'
require './gc_appearences'

class InningHalf

    def initialize(xml_elements)
        @inning_half_str = xml_elements[0].text
        @appearences = Appearences.new(xml_elements)
    end

    def display_xml
        puts "<inning_half>"
        puts "<description>%s</description>" % @inning_half_str
        @appearences.display_xml
        puts "</inning_half>"
    end


end

