# add copyright header

require 'date'

require './gc_common'

class Touch
    def initialize(touch_xml_element)
        @name = touch_xml_element.css('a').inner_text.strip
        @href = touch_xml_element.css('a @href').to_s
        @number = ""
        @position = ""

        spans = touch_xml_element.css('span')

        # defense touch will have 2, offense only 1
        if spans.length > 1
            @number   = spans[0].inner_text.strip
            @position = spans[1].inner_text.strip
        else
            @position = spans[0].inner_text.strip
        end

    end

    def display_xml
        puts "<touch>"
        puts "<name>%s</name>"         % @name
        puts "<href>%s</href>"         % @href
        puts "<number>%s</number>"     % @number
        puts "<position>%s</position>" % @position
        puts "</touch>"
    end
end
