$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module RailsGame
  VERSION = '0.0.1'
end

# Connectivity, event handling
require "railsgame/juggernaut_connect"
require "railsgame/player_action"
require "railsgame/server"
require "railsgame/command_parser"

# In-game objects, creatures, etc
require "railsgame/mobile"
require "railsgame/player"
require "railsgame/location"

# Methods of interaction
require "railsgame/text_output"
