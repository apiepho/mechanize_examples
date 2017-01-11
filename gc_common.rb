# TODO: add copyright header

require 'json'
require 'nokogiri'
require 'optparse'
require 'ostruct'
require 'pp'
require 'watir'


GC_BASE_URI  = 'https://gc.com'
GC_LOGIN_URI = GC_BASE_URI + '/login'
GC_ROSTER_URI = "%s/roster"
#GC_TEAMS_URI = GC_BASE_URI + '/teams?page_number=0&page_size=1000'
# NOTE: since we are parsing json instead of html, don't need to set page_size
GC_TEAMS_URI = GC_BASE_URI + '/teams'
GC_PLAYS_URI = GC_BASE_URI + "/game-%s/plays"

# debug/status
$total_teams = 0
$total_games = 0
