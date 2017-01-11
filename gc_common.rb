
require 'json'
require 'nokogiri'
require 'optparse'
require 'ostruct'
require 'pp'
require 'watir'


GC_BASE_URI  = 'https://gc.com'
GC_LOGIN_URI = GC_BASE_URI + '/login'
# assume no one will follow more than 1000 teams
#GC_TEAMS_URI = GC_BASE_URI + '/teams?page_number=0&page_size=1000'
# NOTE: since we are parsong json instead of html, don't need to set page_size
GC_TEAMS_URI = GC_BASE_URI + '/teams'

# debug/status
$total_teams = 0
$total_games = 0

