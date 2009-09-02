class <%= class_name -%>Controller < ApplicationController
  include AuthenticatedSystem

  jug_methods = [:jug_login, :jug_logout, :jug_con_logout, :jug_broadcast]
  #layout "game", :except => jug_methods
  protect_from_forgery :except => jug_methods

  before_filter :login_required, :only => [ 'full' ]

  include ActionView::Helpers::JavaScriptHelper # for escape_javascript
  include ERB::Util # for html_escape, aka h()

  def home
    current_user   # set @current_user variable
  end

  def full
    current_user   # set @current_user variable
    @jcookie = cookies[ActionController::Base.session_options[:key]]
  end

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
    render :nothing => true
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

  def send_chat_data
    command = "add_chat(\"#{current_user.login}\", " +
        "\"#{escape_javascript h params[:chat_input]}\")"
    js = "try { #{command} } catch(e) { alert('chat error') } "
    Juggernaut.send_to_channels(js, ["chat"]);
    render :nothing => true
  end

  def send_action_text
    hash = { :client => current_user.login, :type => :action,
             :verb => 'parse', :objects => params[:action_text] }
    Juggernaut.send_to_channels(hash.to_json, "action")

    render :nothing => true
  end

end
