class MyGameServer < RailsGame::Server

  # Define new function names for new actions
  def action_think(player, objects)
    player.send_html("You think '#{h objects}'. <br />")
  end

  def unknown_action(player, verb, objects)
    player.send_html("I don't know the verb '#{h verb}'.  Sorry! <br />")
  end
end
