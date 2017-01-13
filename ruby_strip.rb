#!/usr/bin/env ruby -i

block = false

STDIN.read.split("\n").each do |a|
    block   = true if a.start_with?("=begin")
    comment = (a.strip.start_with?("#") ? true : false)
    blank   = (a.strip.empty? ? true : false)

    puts a  if not block and not comment and not blank

    block   = false if a.start_with?("=end")
end
