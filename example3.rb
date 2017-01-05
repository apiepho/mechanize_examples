require 'mechanize'

email = 'alpiepho@yahoo.com'
password = 'jjjzzzkkk'
GC_BASE_URI  = 'https://gc.com'
GC_LOGIN_URI = GC_BASE_URI + '/login'
GC_TEAM_MAX  = '100'
GC_TEAMS_URI = GC_BASE_URI + '/teams?page_number=0&page_size=' + GC_TEAM_MAX


class Team
    attr_accessor :complex_name
    attr_accessor :relative_href
    attr_accessor :href
    attr_accessor :name
# possible fields
#    .parsed_name
#    .parsed_href
#    .name
#    .sport
#    .season
#    .year
#    .total_games
#    .games


	def initialize(mechanize, complex_name, relative_href)
	    # save given params
	    @mechanize = mechanize
		@complex_name = complex_name
		@relative_href = relative_href

        # parse the params
		@name = complex_name.gsub("Baseball", "").gsub("Softball", "").gsub("Fan", "").gsub("·", "").strip
		@href = GC_BASE_URI + @relative_href
		
		# get info from the team page
		page = mechanize.get(@href)
        puts "======================="
        puts @name
        puts "======================="
        pp page.body

	end
	
	def display(full = false)
		puts "%s"   % @name
		puts "  %s" % @complex_name   if full
		puts "  %s" % @relative_href  if full
		puts "  %s" % @name
		puts "  %s" % @href
	end
end

def dump_teams(teams)
	teams.each do |team|
	  #team.display(full=true)
	  team.display
	end
	puts "total: %d" % teams.length
end

# get a new instance of Mechanize class
mechanize = Mechanize.new

# login
page = mechanize.get(GC_LOGIN_URI)
form = page.forms.first

form['email']    = email
form['password'] = password
form.submit

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

#list = page.parser.css('button')
#puts list.class
#puts list.length
#list.each do |item|
#	puts "%-20s: %s" % [item.class, item.text]
#end

# login

# get teams
page = mechanize.get(GC_TEAMS_URI)
#pp page.body

# using href that start with /t/ and include 
team_links = []
page.links.each do |link|
    team_links << link if link.href.to_s.start_with?('/t/') and link.text.include?(' Fan ')
end

teams = []
team_links.each do |link|
    team = Team.new(mechanize, link.text, link.href)
    teams << team
end

dump_teams(teams)







