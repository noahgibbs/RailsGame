require "activesupport"

class RailsGame::Server < RailsGame::JuggernautConnect
  def initialize
    @last_interval = Time.now
  end

  def jug_hosts_file(file)
    config_file(file)
  end

  # How often to check for input
  PollInterval = 1.second

  def sleep_until_next_poll
    # Sleep until PollInterval after the most recent polling
    next_interval = @last_interval + PollInterval
    now = Time.now

    time_slept = 0
    time_slept = next_interval - now if next_interval > now

    @last_interval = next_interval
    sleep time_slept if time_slept > 0
  end

  def process_player_action(rbody)
    if rbody.kind_of? String
      begin
        rh = ActiveSupport::JSON.decode(rbody)
        raise "Invalid JSON hash from Juggernaut!" unless rh['type']
        if rh['type'] == 'action'
          print "GameServer: Got action #{rh['verb']} from #{rh['client']}.\n"
          RailsGame::PlayerAction::received(self, rh['client'], rh['verb'], rh['objects'])
        else
          print "GameServer: Can't yet process non-action JSON hashes!\n"
        end
      rescue ActiveSupport::JSON::ParseError
        print "GameServer: Received non-JSON string [#{rbody}].  Not for us?\n"
      end
    else
      raise "GameServer: Invalid object received from Juggernaut!"
    end
  end

  def loop_while_connected
    while(connected?) do
      responses = poll
      responses.each do |r|
        raise "Invalid object received from Juggernaut!" unless
	    r.kind_of? Hash

        rb = r['body']
        begin
          process_player_action(rb)
        rescue => e
          print e.inspect
          print e.backtrace
        end
      end

      # TODO: all that interesting game stuff not triggered by players

      sleep_until_next_poll
    end
  end

end
