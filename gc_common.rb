# add copyright header

require 'fileutils'
require 'json'
require 'nokogiri'
require 'optparse'
require 'ostruct'
require 'pp'
require 'watir'

require './gc_browser'

GC_APP_VERSION = "0.1"

GC_BASE_URI  = 'https://gc.com'
GC_LOGIN_URI = GC_BASE_URI + '/login'

#GC_TEAMS_URI                      = GC_BASE_URI + '/teams?page_number=0&page_size=1000'
# NOTE: since we are parsing json instead of html, don't need to set page_size
GC_TEAMS_URI                      = GC_BASE_URI + '/teams'
GC_PLAYS_URI                      = GC_BASE_URI + "/game-%s/plays"
GC_SCOREBOOK_URI                  = GC_BASE_URI + "/game-%s/scorebook"

GC_ROSTER_URI                     = "%s/roster"                # given team guid
GC_PLAYER_URI                     = "%s/p/%s"                  # given team guid and player fname-lastinitial-guid
GC_RECAP_URI                      = "%s/game-%s/recap-story"   # given base and game guid

GC_STATS_URI                      = "%s/game-%s/stats"         # given base and game guid

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

$options         = nil
$gc_parse        = nil
$browser         = nil
$browser_private = nil

# debug/status
$total_teams     = 0
$total_players   = 0
$total_games     = 0

class GCParse

    def initialize()
    end

    def decode(html_str)
        temp = html_str                                            # get body as a string
        json_encoded = temp.match(/ \$\.parseJSON.*$/)             # get the JSON data
        json_encoded = json_encoded.to_s                           # convert MatchData to a string
        json_encoded = json_encoded.gsub("\\u0022", "\"")          # convert unicode quote
        json_encoded = json_encoded.gsub("\\u002D", "-")           # convert unicode hyphen
        json_encoded = json_encoded.gsub(" \$\.parseJSON(\'", "")  # remove leading cruft
        json_encoded = json_encoded.gsub(" \$\.parseJSON(\"", "")  # remove leading cruft
        json_encoded = json_encoded.gsub("\'),", "")               # remove trailing cruft
        json_encoded = json_encoded.gsub("\"),", "")               # remove trailing cruft
        json_decoded = JSON.parse json_encoded                     # conver to a hash
        json_decoded
    end
end


