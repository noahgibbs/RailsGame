require "redis"
require "multi_json"

module MessageHooks
  JUG_CHANNELS = [
                  "juggernaut:subscribe",
                  "juggernaut:unsubscribe",
                  "juggernaut:custom",
                  "juggernaut"
                 ]

  def redis_object(options = {})
    @redis_obj ||= Redis.new(options)
  end

  #Juggernaut.publish("channel1", "Some data")
  #Redis.new.publish("juggernaut", { "channels" => [ "channel1"], "data" => "Some data"})
  #Juggernaut.publish("channel1", {:some => "data"})
  #Juggernaut.publish(["channel1", "channel2"], ["foo", "bar"])
  def jug_publish(channels, data)
    message =  MultiJson.dump({ :channels => channels, :data => data })
    redis_object.publish("juggernaut", message)
  end

  def jug_message(channels, data)
    # Received message
    STDERR.puts "Message -> Channels: #{channels.inspect} Data: #{data.inspect}"
  end

  def jug_subscribe(channel, client)
    # Received subscribe
    STDERR.puts "Subscribe -> Channel: #{channel.inspect} Client: #{client.inspect}"
  end

  def jug_unsubscribe(channel, client)
    # Received unsubscribe
    STDERR.puts "Unsubscribe -> Channel: #{channel.inspect} Client: #{client.inspect}"
  end

  def jug_event(type, data)
    # Received custom event
    STDERR.puts "Custom Event -> Type: #{type.inspect} Data: #{data.inspect}"
  end

  # Blocking call
  def jug_message_loop
    redis_object.subscribe(JUG_CHANNELS) do |on|

      on.message do |type, msg|
        if type == "juggernaut"
          msg_hash = MultiJson.load msg
          if msg_hash
            jug_message(msg_hash["channels"], msg_hash["data"])
          else
            STDERR.puts "Couldn't parse as JSON: #{msg.inspect}"
          end
        elsif type["juggernaut:"]
          event_type = type.sub("juggernaut:", "")
          msg_hash = MultiJson.load msg
          case event_type
          when "subscribe"
            jug_subscribe(msg_hash["channel"], msg_hash["session_id"])
          when "unsubscribe"
            jug_unsubscribe(msg_hash["channel"], msg_hash["session_id"])
          else
            jug_event(event_type, msg_hash)
          end
        else
          STDERR.puts "ERROR: unrecognized message type #{type.inspect}!"
        end
      end
    end
  end

end
