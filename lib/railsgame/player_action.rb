gem "actionpack"
require "action_view/erb/util"

module RailsGame::PlayerAction
  class << self
    include ERB::Util
  end

  def self.received(server, player, verb, objects)
    if verb == 'login'
      RailsGame::Player.server_login(server, player, objects)
      return
    elsif verb == 'logout'
      Player.server_logout(server, player, objects)
      return
    end

    pobj = RailsGame::Player.by_name(player)

    verb, objects = CommandParser.process(player, objects) if verb == 'parse'
    objects = [objects] unless objects.kind_of? Array

    print "PlayerAction: #{verb} on [#{objects.join(" / ")}]\n"

    if verb == 'think'
      pobj.send_html("You think to yourself, \"#{h objects.join(' ')}\". " +
      			"<br />")
    end
  end
end
