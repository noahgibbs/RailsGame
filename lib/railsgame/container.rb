# This module is meant to ease dynamically creating containers (divs,
# usually) in the user's output window.  Instead of having a fixed
# screen layout, the game server can dictate the screen layout,
# including various changes, dynamically and scriptably.

module RailsGame::Container

  include ActionView::Helpers::JavaScriptHelper # for javascript_escape
  include ERB::Util  # for html_escape aka h

  def initialize(player, id, options = {})
    player.class.include? RailsGame::Player or raise "Invalid player object!"

    @player = player
    @id = id
  end

end
