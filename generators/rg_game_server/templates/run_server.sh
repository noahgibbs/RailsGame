#!/bin/bash

# This script runs the MUD server, including auxiliary services like
# Juggernaut.  Rails has many fine deployment methods.  This gives only
# the most basic, where you run everything on a single server together.

if [ -r private_variables.sh ]
then
  . private_variables.sh
else
  echo You have not created private_variables.sh!  Read INSTALL for details.
  exit
fi

if [ -r crypto_keys.sh ]
then
  . crypto_keys.sh
else
  echo Generating new cryptographic keys for this installation.
  RM_RAILS_SESSION_SECRET="NotAVeryGoodSecretButItLetsTheGeneratorRun" ./script/generate rg_crypto_keys
  . crypto_keys.sh
fi

# For now, crash and die on hangup, too.  That'll be worth changing later.
trap "ruby rails_control.rb stop; ruby juggernaut_control.rb stop; exit" INT TERM EXIT HUP

# Rails server for player UI and the web site
#./script/server -p $RM_SITE_PORT -e $RM_RAILS_ENVIRONMENT &
ruby rails_control.rb start -- -p $RM_SITE_PORT -e $RM_RAILS_ENVIRONMENT

# Juggernaut server for pushing chat, text and certain AJAX data
# $RM_JUGGERNAUT_HOST must be this machine if you don't change this
#juggernaut -c juggernaut.yml &
ruby juggernaut_control.rb start

echo "Delaying while Juggernaut starts..."
sleep 2

# MUD server for coordinating the environment
# $RM_GAMESERVER_HOST must be this machine if you don't change this
ruby ./game/server.rb -p $RM_GAMESERVER_PORT

# Game server stopped, stop other servers
ruby juggernaut_control.rb stop
ruby rails_control.rb stop
