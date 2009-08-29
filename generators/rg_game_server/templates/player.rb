gem "railsgame"
require "railsgame"

require "start_location"

class BasicPlayer
  include RailsGame::Player  # This sets BasicPlayer as the active Player class

  def self.login(name, objects)
    RailsGame::Player.login(name, objects)
    player = RailsGame::Player.by_name(name)
    player.send_html("Welcome to #{ENV['RG_SITE_NAME']}, #{name}! <br />")

    player.move_to(StartLocation.instance())
    player.show_current_location
  end

  def self.logout(name, objects)
    player.move_to(nil)
    RailsGame::Player.logout(name, objects)
  end

end
