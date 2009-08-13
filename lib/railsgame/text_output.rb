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

module RailsGame::Mobile
  def perceive_text
    # For the default mobile, this is a no-op
  end

  def perceive_text_event(event, options)
    # For the default mobile, this is a no-op
  end
end

module RailsGame::Player
  def perceive_text(text)
    send_html(text)
  end

  def perceive_text_event(event, options)
    if(options[:actor] == self && event[:actor])
      send_html(event[:actor])
      return
    end

    if(options[:victim] == self && event[:victim])
      send_html(event[:victim])
      return
    end

    send_html(event[:default])
  end
end

module RailsGame::Location
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
