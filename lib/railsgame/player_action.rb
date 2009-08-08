gem "actionpack"
require "action_view/erb/util"

module RailsGame::PlayerAction
  class << self
    include ERB::Util
  end

  def self.received(player, verb, objects)
    if verb == 'login'
      RailsGame::Player.server_login(player, objects)
      return
    elsif verb == 'logout'
      Player.server_logout(player, objects)
      return
    end

    verb, objects = CommandParser.process(player, objects) if verb == 'parse'
    objects = [objects] unless objects.kind_of? Array

    print "PlayerAction: #{verb} on [#{objects.join(" / ")}]\n"

    if verb == 'think'
      RailsGame::Player.send_to_players("You think to yourself, \"#{h objects.join(' ')}\". <br />",
                             [player])
    end
  end
end
