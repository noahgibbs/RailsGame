# This module is meant to ease dynamically creating containers (divs,
# usually) in the user's output window.  Instead of having a fixed
# screen layout, the game server can dictate the screen layout,
# including various changes, dynamically and scriptably.

module RailsGame::Container

  include ActionView::Helpers::PrototypeHelper # for remote_form_for
  include ActionView::Helpers::JavaScriptHelper # for javascript_escape
  include ERB::Util  # for html_escape aka h

  def default_container_location
    "rg_containers"
  end

  def default_div(id)
    div_with_body(dom_id, "<p id=\"#{dom_id}_data\" class=\"data\"> </p>")
  end

  def div_with_body(id, body)
    <<-END
  <div id="#{id}">
    <p id="#{id}_debug" class="debug"> </p>
    #{body}
  </div>
    END
  end

  def text_field(id, options)
    field_id = options[:field_id] || "#{id}_form_text"
    form_remote_tag(:complete => options[:field_complete],
                    :url => options[:field_url]) +
    text_field_tag(field_id, '', { :size => options[:field_size] || 30,
    			     	   :id => field_id }) +
    submit_tag(options[:field_submit] || "Do It")
  end

  def initialize(player, id, options)
    player.include? RailsGame::Player or raise "Invalid player object!"

    @player = player
    @id = id

    nodiv = options.delete :nodiv
    noform = option.delete :noform
    js = ""
    at_id = options[:at] || default_container_location

    unless nodiv
      innerHTML = default_div(id)

      js += "$('#{at_id}').innerHTML = #{escape_javascript(innerHTML)}"
    end

    unless noform
      innerHTML = text_field(id, {:field_id => "#{id}_chat",
      		  		  :url => {:action => :send_chat_text,
                                           :container => id},
                                  :complete => "$('#{id}_chat').value = ''"})
      js += "$('#{at_id}').innerHTML = #{escape_javascript(innerHTML)}"
    end

    @player.send_javascript(js)
  end

  def destroy(options = {})
    @player.send_javascript("$(\"#{@id}\").remove()") unless options[:noremove]
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
    super(player, id, options.merge({ :nodiv => true }))

    return nil if options[:nodiv]

    at_id = options.delete("at") || default_container_location
    innerHTML = div_with_body(id, "<ul id=\"#{id}_data\" class=\"data\" style=\"list-style: none\"> </ul>")

    js = "$('#{at_id}').innerHTML = #{escape_javascript(innerHTML)}"

    @player.send_javascript(js)
  end

end
