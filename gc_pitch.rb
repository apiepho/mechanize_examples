# add copyright header

require './gc_common'

class Pitch

	def initialize(pitch_xml_element)
		@xml_element = pitch_xml_element
		
        # a 'pitch' can be a pitch or an event (out, scored, other)

		# parse pitch_xml_element with Nokogiri		
		#doc = Nokogiri::HTML(temp)
		@description = @xml_element.css('.event_description', '.pitch_description').inner_text.strip
	end
    
	def display
=begin
examples of pitch_xml_element:

<li class="gs_pitch_li invertLinkUnderline playByPlayPitch">
    <span class="pitch_description ">
        Ball, 
    </span>
</li>

<li class="gs_pitch_li invertLinkUnderline playByPlayPitch">
    <span class="pitch_description ">
        In play, 
    </span>
</li>

<li class="gs_pitch_li invertLinkUnderline ">
    <span class="event_description ">
         <b><a href="/game/573728119d8c193d56000189/play/573728119d8c1965ee0002e4">Bernhardt, #5 singled to CF, (line drive) [C O'Donnell] Norsen advanced to 3rd</a></b>
    </span>
</li>

<li class="gs_pitch_li invertLinkUnderline ">
    <span class="event_description ">
         <b><a href="/game/573728119d8c193d56000189/play/573728119d8c194e380001d3">Norsen, #17 walked [Garcia, #6]</a></b>
    </span>
</li>

<li class="gs_pitch_li invertLinkUnderline playByPlaySub ">
    <span class="event_description ">
         <b><a href="/game/573728119d8c193d56000189/play/573728119d8c194bf60001b0">Lineup: Bernhardt, #5 to Pitcher</a></b>
    </span>
</li>
=end
		puts "          %s" % @description
	end
end

