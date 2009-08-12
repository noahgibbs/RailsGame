module RailsGame::Location

  def initialize
    @mobiles = []
  end

  def add_mobile(m)
    @mobiles << m
  end

  def remove_mobile(m)
    @mobiles.delete(m)
  end

  def show_to(player)
    raise "Unimplemented!"
  end

end
