#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

RailsConfigDir = File.expand_path(File.join(File.dirname(__FILE__),
					    "..", "config"))

# Include Rails if you need integration with ActiveRecord or ActionPack
#RailsModelsDir = File.expand_path(File.join(File.dirname(__FILE__), "..",
#					    "app", "models"))
#$LOAD_PATH << RailsModelsDir
#require File.expand_path(File.join(RailsConfigDir, "environment"))

gem "railsgame"
require "railsgame"

JuggernautHosts = File.join(RailsConfigDir, "juggernaut_hosts.yml")

# Game objects that don't touch Rails directly
require "start_location"
require "player"
require "actions"

# Actually create the server
server = MyGameServer.new
server.jug_hosts_file(JuggernautHosts)
server.connect

# Just prints whether connection was successful
if server.connected?
  print "GameServer: Connected!\n"
else
  print "GameServer: Not Connected!\n"
end

server.loop_while_connected

print "GameServer: exited\n"
