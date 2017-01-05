require 'mechanize'

# set the page uri
uri = 'http://weblog.rubyonrails.org'
uri = 'http://www.google.com'
uri = 'http://www.gc.com'

# get a new instance of Mechanize class
mechanize = Mechanize.new

# get the page
page = mechanize.get(uri)

# dump the html for the page
#puts page.body

# dump the html for the page
#puts page.content

# dump the title for the page
#puts page.title


#puts page.at('.entry-title').text.strip

# show all links on a page
#puts "======================="
#page.links.each do |link|
#	puts "%-20s: %s" % [link.text, link.href]
#end
#puts page.links.length

list = page.parser.css('button')
puts list.class
puts list.length
list.each do |item|
	puts "%-20s: %s" % [item.class, item.text]
end
