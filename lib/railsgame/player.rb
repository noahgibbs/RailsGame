gem "actionpack"
require "action_view"
require "action_view/erb/util"

class RailsGame::Player < RailsGame::Mobile
  attr_reader :login
  attr_accessor :server
  @@players = {}
  @@playerclass = RailsGame::Player

  include ActionView::Helpers::JavaScriptHelper # for javascript_escape
  include ERB::Util  # for html_escape aka h

  def self.playerClass
    @@playerclass = self
  end

  def initialize(login)
    @login = login
  end

  def self.server_login(server, name, objects)
    options = { :login => name, :server => server }

    @@playerclass.login(name, options)
    player = self.by_name(name)

    player or raise "Player doesn't exist after login!  Call super!"
  end

  def self.login(name, options)
    p = @@playerclass.new(name)
    @@players[name] = p
    p.server = options[:server]
  end

  def self.server_logout(server, name, objects)
    options = { :login => name, :server => server }

    player = self.by_name(name)
    raise "Player doesn't exist!  Don't log him out!" unless player
    raise "Player logging out from wrong server!" unless player.server == server

    @@playerclass.logout(name, options)

    raise "Player still tracked!  Call super!" if @@players[name]
  end

  def self.logout(name, options)
    @@players.delete(name)
  end

  def self.by_name(name)
    @@players[name]
  end

  def self.send_html_to_players(text, players)
    players = [players] unless players.kind_of? Array

    players.each do |p|
      p.send_html(text)
    end
  end

  def send_html(text)
    str = javascript_from_html(text)
    @server.send_to_clients(str, @login)
  end

  private

  def javascript_from_html(text)
    "try {\nadd_world_output(\"#{escape_javascript(text)}\");\n} " +
    "catch (e) { " +
        "alert('GS error:\\n\\n' + e.toString()); " +
        "alert('add_world_output(\\\"\#{text}\\\");'); throw e }"
  end

end
