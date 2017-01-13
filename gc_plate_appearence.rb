# add copyright header

require './gc_common'
require './gc_pitch'

class PlateAppearence
    attr_reader :score_away, :score_home

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
            @pitches << Pitch.new(xml_element)
        end
        @pitches = @pitches.reverse

        # parse running score
		xml_elements = @xml_element.css('.scoreColumn')
        @score_away = xml_elements[0].inner_text.to_i
        @score_home = xml_elements[1].inner_text.to_i
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
		puts "%s%s" % [ $indent.str, "pitches:" ]
        $indent.increase
		@pitches.each do |pitch|
			pitch.display
		end
        $indent.decrease
		puts "%s%s%d"      % [ $indent.str, "pitches total: ", @pitches.length ]
		puts "%s%s%2d %2d" % [ $indent.str, "running score: ", @score_away, @score_home ]
	end
end

