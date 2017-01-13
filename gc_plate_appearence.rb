# add copyright header

require './gc_common'

class PlateAppearence

	def initialize(plate_appearence_xml_element)
		@xml_element = plate_appearence_xml_element
		
		# parse plate_appearence_xml_element with Nokogiri		
		#doc = Nokogiri::HTML(temp)
		xml_elements = @xml_element.css('.gs_pitch_li')
		xml_elements = xml_elements.reverse

		# build list of pitches
		@pitches = []
        xml_elements.each do |xml_element|
			next if not $options.pitches.nil? and @pitches.length >= $options.pitches.to_i
#            @pitches << Pitch.new(xml_element)
        end
	end
    
	def display
=begin
<tr class="plateAppearanceRow bbm">
<td class="pvm phml gs_plateappearance_content wordBreak">
    <ul class="gs_pitchbypitch_ul pln">
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
</ul>
</td>
<td class="centerAlign scoreColumn ptm">0</td>
<td class="centerAlign scoreColumn ptm">9</td>
</tr>
=end
		puts @xml_element
		puts "pitches: %d" % @pitches.length
	end
end

