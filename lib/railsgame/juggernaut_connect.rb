# Code for connecting to the Juggernaut server.

require "yaml"
require "socket"
require "erb"
require "activesupport"

module RailsGame::JuggernautConnect
  #CONFIG = YAML::load(ERB.new(IO.read("#{File.dirname(__FILE__)}/../../config/juggernaut_hosts.yml")).result).freeze
  CONFIG = YAML::load(ERB.new(IO.read("/home/angelbob/rails/RailsMUD/config/juggernaut_hosts.yml")).result).freeze
  CR = "\0"

  def self.connect
    @sockets.nil? || @sockets.empty? or raise "Already connected to Juggernaut"
    handshake = { :command => :subscribe,
                  :session_id => ENV['RM_JUGGER_GS_SESSION'],
                  :client_id => :gameserver,
                  :channels => [ :action ]
                }

    h = self.hosts

    @sockets = []
    @sockbuf = h.map { "" }
    h.each do |address|
      hash = handshake.dup
      hash[:secret_key] = address[:secret_key] if address[:secret_key]

      socket = TCPSocket.new(address[:host], address[:port])
      socket.print(hash.to_json + CR)
      socket.flush
      @sockets << socket
    end 

    @sockets.each {|s| !s.nil?} or raise "Error opening sockets!"
  end

  def self.disconnect
    @sockets.each { |s| s.close }
    @sockets = nil
    @sockbuf = nil
  end

  def self.connected?
    @sockets and !@sockets.empty?
  end

  def self.poll
    res = []
    @sockets.each_index do |idx|
        s = @sockets[idx]
        begin
	  msg, s_sa = s.recv_nonblock(10240)
	rescue Errno::EAGAIN, Errno::EWOULDBLOCK, Errno::EINTR,
	       Errno::ENOMEM, Errno::ENOBUFS, Errno::ENOSR, Errno::ETIMEDOUT,
               Errno::EINPROGRESS
          # The preceding are all recoverable "try again" errors
          msg = nil
        rescue => err
	  self.disconnect
          raise "Unfixable error [#{err}] reading from Juggernaut!"
	end

	# An empty msg string is an EOF.  Nil means EWOULDBLOCK.
        if msg == ""
          self.disconnect
          return []
        elsif msg != nil
          @sockbuf[idx] += msg

          empty_buffer = false # Whether we'll use up the whole buffer
	  empty_buffer = true if @sockbuf[idx].chomp!(CR)

          chunks = @sockbuf[idx].split(CR)
          @sockbuf[idx] = ""
	  @sockbuf[idx] = chunks.pop unless empty_buffer
	  print "JugCon: got #{chunks.size} chunks...\n"
	  print "JugCon: chunks: #{chunks.join ' *** '} (End chunks)\n"

          newhashes = chunks.map {|chunk|
            newhash = ActiveSupport::JSON.decode(chunk)
	  }

	  print "JugCon: got #{newhashes.size} hashes.\n"
	  print "JugCon: hashes: #{newhashes.join ' *** '} (End hashes)\n"

          res += newhashes
        end

	#print "JugCon: No message, but not blocking\n" if msg.nil?
    end
    res
  end

  # Code for outgoing data is taken from the Juggernaut Rails plugin.
  def self.hosts
    CONFIG[:hosts].select {|h|
      !h[:environment] or h[:environment].to_s == ENV['RM_RAILS_ENVIRONMENT']
    }
  end

  def self.send_data(hash)
    hash[:channels] = hash[:channels].to_a if hash[:channels]
    hash[:client_ids] = hash[:client_ids].to_a if hash[:client_ids]

    h = self.hosts
    h.each_index do |idx|
      address = h[idx]
      socket = @sockets[idx]

      hash[:secret_key] = address[:secret_key] if address[:secret_key]
      hash[:session_id] = ENV['RM_JUGGER_GS_SESSION']

      # Zero-terminate
      socket.print(hash.to_json + CR)
      socket.flush
    end
  end

  def self.send_to_all(data)
    fc = {
      :command   => :broadcast,
      :body      => data, 
      :type      => :to_channels,
      :channels  => []
    }
    self.send_data(fc)
  end

  def self.send_to_clients(data, client_ids)
    fc = {
      :command    => :broadcast,
      :body       => data, 
      :type       => :to_clients,
      :client_ids => client_ids
    }
    self.send_data(fc)
  end

end
