# add copyright header

require './gc_common'
require './gc_appearence'

class Appearences

    def initialize(appearence_xml_element)
        @appearences = []
        appearence_xml_element.each do |xml_element|
            next if not $options.appearences.nil? and @appearences.length >= $options.appearences.to_i
            @appearences << Appearence.new(xml_element)
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

