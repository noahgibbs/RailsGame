class RailsgameController < ApplicationController
  include AuthenticatedSystem

  jug_methods = [:jug_login, :jug_logout, :jug_con_logout, :jug_broadcast]
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

end
