class <%= class_name -%>Controller < ApplicationController
  include AuthenticatedSystem

  before_filter :login_required, :only => [ 'full', 'send_chat_data',
  				       	    'send_action_text' ]

  include ActionView::Helpers::JavaScriptHelper # for escape_javascript
  include ERB::Util # for html_escape, aka h()

  def home
    current_user   # set @current_user variable
  end

  def full
    current_user   # set @current_user variable
    @jcookie = cookies[ActionController::Base.session_options[:key]]
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
