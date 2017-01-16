# add copyright header

require 'date'

require './gc_common'
require './gc_touch'

class Play

    def initialize(play_href)

        # get pitch play page
        uri = GC_BASE_URI + play_href
        puts "getting %s ..." % uri if $options.debug
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

    def display
        puts "%s%s" % [ $indent.str, "play: "]
        $indent.increase
        puts "%s%s" % [ $indent.str, "defense: "]
        $indent.increase
        @defense.each do |touch|
        	touch.display
        end
        $indent.decrease
        puts "%s%s" % [ $indent.str, "offense: "]
        $indent.increase
        @offense.each do |touch|
        	touch.display
        end
        $indent.decrease
        puts "%s%s%s" % [ $indent.str, "recap: ", @recap ]
        $indent.decrease
    end

    def display_xml
        puts "<play>"
        puts "<defense>"
        @defense.each do |touch|
        	touch.display
        end
        puts "</defense>"
        puts "<offense>"
        @defense.each do |touch|
        	touch.display
        end
        puts "</offense>"
        puts "<recap>%s</recap>" % @recap
        puts "</play>"
    end
end
