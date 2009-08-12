# This module describes how textual string and events are perceived by
# the player in a console-like fashion.  While HTML can be sent this
# way, it will be appended to the bottom of an HTML container with
# vertical scrolling, like a good old-fashioned terminal.

# A text event is represented by a hash table containing entries for
# what will be perceived by the doer (if any), the target (if any),
# and any other viewers.  Other entries may be added later.

module RailsGame::Text
  class Event
    attr :default
    attr :actor_text
    attr :victim_text

    def initialize(default, actor_text = nil, victim_text = nil)
      @default, @actor_text, @victim_text = [default, actor_text, victim_text]
    end

    def [](arg)
      return @default if arg.to_s == 'default'
      return @actor_text if arg.to_s == 'actor'
      return @victim_text if arg.to_s == 'victim'
      nil
    end

  end

end

class RailsGame::Mobile
  def perceive_text
    # For the default mobile, this is a no-op
  end

  def perceive_text_event(event, options)
  end
end

class RailsGame::Player
  def perceive_text(text)
    Player.send_to_players(text, self)
  end

  def perceive_text_event(event, options)
    if(options[:actor] == self && event[:actor])
      Player.send_to_players(event[:actor], self)
      return
    end

    if(options[:victim] == self && event[:victim])
      Player.send_to_players(event[:victim], self)
      return
    end

    Player.send_to_players(event[:default], self)
  end
end

class RailsGame::Location
  def show_text(text)
    @mobiles.each do |m|
      m.perceive_text(text)
    end
  end

  def show_text_event(event, options)
    @mobiles.each do |m|
      m.perceive_text_event(event, options)
    end
  end
end
