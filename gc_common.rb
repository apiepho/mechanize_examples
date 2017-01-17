# add copyright header

require 'fileutils'
require 'json'
require 'nokogiri'
require 'optparse'
require 'ostruct'
require 'pp'
require 'watir'

require './gc_browser'
require './gc_indent'


GC_BASE_URI  = 'https://gc.com'
GC_LOGIN_URI = GC_BASE_URI + '/login'
GC_ROSTER_URI = "%s/roster"           # given team guid
GC_PLAYER_URI = "%s/p/%s"             # given team guid and player fname-lastinitial-guid

# parameters for the following: [GC_BASE_URI, fteam, team_id, fname, linitial, player_id]
GC_PLAYER_BATTING_STANDARD_URI    = "%s/t/%s-%s/p/%s-%s-%s/batting/standard"
GC_PLAYER_BATTING_SPEED_URI       = "%s/t/%s-%s/p/%s-%s-%s/batting/expanded"
GC_PLAYER_BATTING_TEAMIMPACT_URI  = "%s/t/%s-%s/p/%s-%s-%s/batting/expanded2"
GC_PLAYER_PITCHING_STANDARD_URI   = "%s/t/%s-%s/p/%s-%s-%s/pitching/standard"
GC_PLAYER_PITCHING_EFFICIENCY_URI = "%s/t/%s-%s/p/%s-%s-%s/pitching/expanded"
GC_PLAYER_PITCHING_COMMAND_URI    = "%s/t/%s-%s/p/%s-%s-%s/pitching/expanded2"
GC_PLAYER_PITCHING_BATTER_URI     = "%s/t/%s-%s/p/%s-%s-%s/pitching/expanded3"
GC_PLAYER_PITCHING_RUNS_URI       = "%s/t/%s-%s/p/%s-%s-%s/pitching/expanded4"
GC_PLAYER_PITCHING_PITCH_URI      = "%s/t/%s-%s/p/%s-%s-%s/pitching/expanded5"
GC_PLAYER_FIELDING_STANDARD_URI   = "%s/t/%s-%s/p/%s-%s-%s/fielding/standard"
GC_PLAYER_FIELDING_CATCHING_URI   = "%s/t/%s-%s/p/%s-%s-%s/fielding/expanded"
GC_PLAYER_BATTING_SPRAY_URI       = "%s/t/%s-%s/p/%s-%s-%s/spray-chart"

=begin
# parameters for the following: [GC_BASE_URI, player_id]
GC_PLAYER_BATTING_STANDARD_URI    = "%s/p/p-%s/batting/standard"
GC_PLAYER_BATTING_SPEED_URI       = "%s/p/p-%s/batting/expanded"
GC_PLAYER_BATTING_TEAMIMPACT_URI  = "%s/p/p-%s/batting/expanded2"
GC_PLAYER_PITCHING_STANDARD_URI   = "%s/p/p-%s/pitching/standard"
GC_PLAYER_PITCHING_EFFICIENCY_URI = "%s/p/p-%s/pitching/expanded"
GC_PLAYER_PITCHING_COMMAND_URI    = "%s/p/p-%s/pitching/expanded2"
GC_PLAYER_PITCHING_BATTER_URI     = "%s/p/p-%s/pitching/expanded3"
GC_PLAYER_PITCHING_RUNS_URI       = "%s/p/p-%s/pitching/expanded4"
GC_PLAYER_PITCHING_PITCH_URI      = "%s/p/p-%s/pitching/expanded5"
GC_PLAYER_FIELDING_STANDARD_URI   = "%s/p/p-%s/fielding/standard"
GC_PLAYER_FIELDING_CATCHING_URI   = "%s/p/p-%s/fielding/expanded"
GC_PLAYER_BATTING_SPRAY_URI       = "%s/p/p-%s/spray-chart"
=end

#GC_TEAMS_URI = GC_BASE_URI + '/teams?page_number=0&page_size=1000'
# NOTE: since we are parsing json instead of html, don't need to set page_size
GC_TEAMS_URI = GC_BASE_URI + '/teams'
GC_PLAYS_URI = GC_BASE_URI + "/game-%s/plays"

$indent = nil
$options = nil
$browser = nil
$browser_private = nil

# debug/status
$total_teams = 0
$total_players = 0
$total_games = 0

