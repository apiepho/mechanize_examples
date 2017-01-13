#!/usr/bin/env ruby -i

Old = "# add copyright header"
Header = DATA.read

ARGF.each_line do |e|
  puts Header if ARGF.pos - e.length == 0
  puts e if not Old.empty? and not e.include? Old
end

__END__
#
# Copyright (C) 2017 ThatNameGroup, Inc.
#
