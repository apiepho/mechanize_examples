# add copyright header

require 'date'

require './gc_common'
require './gc_touch'

class Play

    def initialize(play_href)

        # get pitch play page
        uri = GC_BASE_URI + play_href
        $browser.goto(uri)

        # parse html with Nokogiri
        doc = Nokogiri::HTML($browser.html)
        @recap = doc.css('div.giganticText.pvl').inner_text.strip

        # each play has 2 lists, defense and offense
        playerList = doc.css('.playerList')

        # build defense touches
        @defense = []
        h2s = playerList[0].css('h2')
        h2s.each do |h2|
            @defense << Touch.new(h2)
        end

        # build offense touches
        @offense = []
        h2s = playerList[1].css('h2')
        h2s.each do |h2|
            @offense << Touch.new(h2)
        end
    end

    def display_xml
        puts "<play>"
        puts "<defense>"
        @defense.each do |touch|
            touch.display_xml
        end
        puts "</defense>"
        puts "<offense>"
        @offense.each do |touch|
            touch.display_xml
        end
        puts "</offense>"
        puts "<recap>%s</recap>" % @recap
        puts "</play>"
    end
end

