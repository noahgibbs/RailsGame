class RailsGame::Mobile
  attr_reader :location

  def move_to(loc)
    @location.remove_mobile(self) unless @location.nil?
    loc.add_mobile(self) unless loc.nil?
    @location = loc
  end
end
