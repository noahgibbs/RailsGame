class RailsgameController < ApplicationController
  include AuthenticatedSystem

  include ActionView::Helpers::JavaScriptHelper # for escape_javascript
  include ERB::Util # for html_escape, aka h()

  jug_methods = [:jug_login, :jug_logout, :jug_con_logout, :jug_broadcast]

  before_filter :login_required, :except => jug_methods
  protect_from_forgery :except => jug_methods

  # Juggernaut subscription URL
  def jug_login
    if params[:client_id] == "gameserver"
      if params[:session_id] != ENV['RG_JUGGER_GS_SESSION']
        # That's not the shared secret we wanted.  Fail!
        render :nothing => true, :status => 501
        return
      end
      render :text => "dummy"
      return
    end

    if(current_user.login != params[:client_id])
      render :nothing => true, :status => 502
      return
    end
    hash = { :client => params[:client_id], :type => :action,
             :verb => 'login',
             :objects => [ :remote_ip => request.remote_ip ] }
    Juggernaut.send_to_client(hash.to_json, "gameserver")

    # Juggernaut seems to sometimes need some text sent or it will take even
    # a status of 200 as failure when it hits EOF.
    render :text => "dummy"
  end

  def jug_logout
    hash = { :client => params[:client_id], :type => :action,
             :verb => 'logout', :objects => "" }
    Juggernaut.send_to_client(hash.to_json, "gameserver")
    render :text => "dummy"
  end

  # We don't normally care about this, and it shouldn't normally happen
  def jug_con_logout
    render :nothing => true, :status => 501
  end

  def jug_broadcast
    # Protect broadcasts from gameserver
    if params[:client_id] == "gameserver"
      if params[:session_id] != ENV['RG_JUGGER_GS_SESSION']
        render :nothing => true, :status => 501
        return
      end
      render :text => "dummy"
      return
    end

    render :nothing => true, :status => 501
  end

  def chat_to_channel
    channel = params[:channel]
    container_id = params[:container_id]
    update_fn = params[:update_fn]

    command = "#{update_fn}(\"#{container_id}\", \"<li>" +
      "&lt;#{current_user.login}&gt;: " +
        "#{escape_javascript h params[:chat_input]}</li>\")"
    js = "try { #{command} } catch(e) { alert('error sending to channel') }"

    Juggernaut.send_to_channels(js, [channel]);
    render :nothing => true
  end

  def send_to_gameserver
    container_id = params[:container_id]
    action_name = params[:action_name]
    id = params[:id]
    form_data = params[id + "_input"]

    hash = { :client => current_user.login, :type => :action,
             :verb => action_name, :objects => form_data }
    Juggernaut.send_to_channels(hash.to_json, "action")

    render :nothing => true
  end

  def init_hexgrid_container
    data_container_id = params[:container_id]
    width = params[:width]
    height = params[:height]

    hash = { :client => current_user.login, :type => :action,
             :verb => "init_hexgrid_container",
	     :objects => {:width => width, :height => height,
	                  :container => data_container_id } }
    Juggernaut.send_to_client(hash.to_json, "gameserver")

    render :nothing => true
  end

  def hexgrid_container_select
    data_container_id = params[:container_id]
    x = params[:x]
    y = params[:y]
    action_name = params[:action_name] || "hex_selected"
    hash = { :client => current_user.login, :type => :action,
             :verb => action_name,
	     :objects => {:x => x, :y => y,
	                  :container => data_container_id } }
    Juggernaut.send_to_client(hash.to_json, "gameserver")

    render :nothing => true
  end

end
