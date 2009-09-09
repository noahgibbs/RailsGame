# This module is meant to ease dynamically creating containers (divs,
# usually) in the user's output window.  Instead of having a fixed
# screen layout, the game server can dictate the screen layout,
# including various changes, dynamically and scriptably.

module RailsGame::Container

  include ActionView::Helpers::JavaScriptHelper # for javascript_escape
  include ERB::Util  # for html_escape aka h

  attr_reader :player, :id

  def initialize(player, id, options = {})
    player.class.include? RailsGame::Player or raise "Invalid player object!"

    @player = player
    @id = id
  end

  def send_html(html, options = {})
    js = javascript_from_html(html)
    @player.send_javascript(js)
  end

  private

  def javascript_from_html(text)
    "try {\nRG.fn.append_to_container(\"#{@id}\", " +
      "\"#{escape_javascript(text)}\");\n} " +
    "catch (e) { " +
        "alert('RG error:\\n\\n' + e.toString()); " +
        "alert('RG.fn.append_to_container(\\\"#{@id}\\\", " +
          "\\\"\#{text}\\\");'); throw e }"
  end

end
