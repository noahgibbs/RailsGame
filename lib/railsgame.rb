$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module RailsGame
  VERSION = '0.0.1'
end

require "railsgame/command_parser"
require "railsgame/juggernaut_connect"
require "railsgame/mobile"
require "railsgame/player"
require "railsgame/player_action"
require "railsgame/location"
require "railsgame/text_output"
