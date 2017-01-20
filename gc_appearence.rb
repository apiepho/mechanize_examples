# add copyright header

require './gc_common'

class Appearence
    attr_reader :score_away, :score_home

    def initialize(play_xml_element)
=begin
# example of an xml_element
    <h4 class="sabertooth_play_header pvs">
        <div>Single</div>        
            <div>
                <span class="separator"> | </span>
                <span class="score">TN 12 - RHS 4</span>
            </div>
            <div>
                <span class="separator"> | </span>
                <span class="outs">2 Outs</span>
            </div>        
    </h4>    
        <section class="pitch_summary pvs">Strike 1 looking, Ball 1, Ball 2, Ball 3, In play.</section>
        <section class="play_description pvs">PlayerB singles on a ground ball to second baseman L Gomez. PlayerA out at 2nd, caught running. PlayerI advances to 3rd. PlayerH scores.</section>
</td>
=end
        @result           = play_xml_element.css('h4 div')
        @result           = (@result.nil? ? "" : @result.text)
        @result           = @result.split(" ")[0]
        @score            = play_xml_element.css('.score')
        @score            = (@score.nil? ? "" : @score.text)
        @outs             = play_xml_element.css('.outs')
        @outs             = (@outs.nil? ? "" : @outs.text)
        @pitch_summary    = play_xml_element.css('.pitch_summary').text
        @play_description = play_xml_element.css('.play_description').text
    end

    def display_xml
        puts "<appearence>"
        puts "<result>%s</result>"                     % @result
        puts "<outs>%s</outs>"                         % @outs
        puts "<score>%s</score>"                       % @score
        puts "<pitch_summary>%s</pitch_summary>"       % @pitch_summary
        puts "<play_description>%s</play_description>" % @play_description
        puts "</appearence>"
    end
end

