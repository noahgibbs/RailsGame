$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module RailsGame
  VERSION = '0.0.1'
end

require "railsgame/command_parser.rb"
require "railsgame/juggernaut_connect.rb"
require "railsgame/player.rb"
require "railsgame/player_action.rb"
require "railsgame/location.rb"
