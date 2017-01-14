#!/usr/bin/env ruby -i

tab = "	"
spaces = "    "

ARGF.each_line do |e|
  puts e.gsub(tab, spaces).rstrip
end
