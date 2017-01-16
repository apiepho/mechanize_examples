# add copyright header

require './gc_common'
require './gc_play'

class Pitch

    def initialize(pitch_xml_element)
        # parse pitch_xml_element with Nokogiri
        #doc = Nokogiri::HTML(temp)
        @event = pitch_xml_element.css('span @class').to_s
        @recap = pitch_xml_element.css('.event_description', '.pitch_description').inner_text.strip        
        @href  = pitch_xml_element.css('a @href').to_s
        @play  = Play.new(@href) if not @href.empty?
    end

    def display
        puts "%s%s" % [ $indent.str, "pitch: " ]
        $indent.increase
        puts "%s%s%s" % [ $indent.str, "event: ", @event ]
        puts "%s%s%s" % [ $indent.str, "href: ", @href ]   if not @href.empty?
        @play.display                                      if not @href.empty?
        puts "%s%s%s" % [ $indent.str, "recap: ", @recap ] if     @href.empty?
        $indent.decrease
    end

    def display_xml
        puts "<pitch>"
        puts "<event>%s</event>" % @event
        puts "<href>%s</href>"   % @href   if not @href.empty?
        @play.display_xml                  if not @href.empty?
        puts "<recap>%s</recap>" % @recap  if     @href.empty?
        puts "</pitch>"
    end

end

