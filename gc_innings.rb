# add copyright header

require 'date'

require './gc_common'
require './gc_inning_half'

class Innings
    def initialize(xml_elements)
        # build list of inning halfs
        @inning_halfs = []

        # parse list of table rows and send subset (inning, play, play, play...) to build inning half
        xml_elements_max   = xml_elements.length - 1
        need_inning        = true
        (0..xml_elements_max).each do |index1|
            element1 = xml_elements[index1]
            is_inning_row = (element1.attribute('class').to_s.include?('sabertooth_pbp_inning_row') ? true : false)
            if is_inning_row
                xml_elements_array = []
                xml_elements_array << element1
                ((index1+1)..xml_elements_max).each do |index2|
                    element2 = xml_elements[index2]
                    is_play_row = (element2.attribute('class').to_s.include?('sabertooth_pbp_row') ? true : false)                        
                    if is_play_row
                        xml_elements_array << element2
                    else
                        supported = ( ($options.halfs.nil? or @inning_halfs.length < $options.halfs.to_i) ? true : false )
                        @inning_halfs << InningHalf.new(xml_elements_array) if supported
                        break
                    end
                end
            end
       end
    end

    def display_xml
        puts "<innings>"
        @inning_halfs.each do |inning_half|
            inning_half.display_xml
        end
        puts "</innings>"
    end
end

