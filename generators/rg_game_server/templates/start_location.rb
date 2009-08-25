class StartLocation
  include RailsGame::Location
  include Singleton

  def show_to(player)
    "This is a sample location.<br/>\n"
  end
end

# Instantiate it
StartLocation.instance()
