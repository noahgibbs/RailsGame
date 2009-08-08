module CommandParser
  def self.process(player, text)
    words = text.split

    verb = words.shift
    [verb, words]
  end
end
