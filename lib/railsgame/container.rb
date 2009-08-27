# This module is meant to ease dynamically creating containers (divs,
# usually) in the user's output window.  Instead of having a fixed
# screen layout, the game server can dictate the screen layout,
# including various changes, dynamically and scriptably.

module RailsGame::Container

  def initialize(player, id, options)
    player.include? RailsGame::Player or raise "Invalid player object!"

    @player = player
    @id = id
  end

  def finalize
    @player.send_javascript("destroy_container(\"#{@id}\")")
  end
end

# A GlobalChatWindow is used to set up player-to-player chat mediated by
# Juggernaut.  The game server is permitted to subscribe to player chat,
# but generally doesn't.  By default, a chat window sends all player
# messages to all players.
#
class RailsGame::GlobalChatWindow
  include RailsGame::Container

  def initialize(player, id, options)
    super(player, id, options)

    @player.send_javascript("add_global_chat_window(\"#{@id}\")")
  end

end
