# This is a Rails template to set up a new RailsGame project

def github_gem(user, gemname, options = {})
  base_opts = { :lib => gemname, :source => "http://gems.github.com" }
  base_opts.merge! options
  gem "#{user}-#{gemname}", base_opts
end

def sub_in_file(filename, regexp, ins_text, options = {})
  fc = IO.read filename
  if options[:force] or !fc.include?(ins_text)
    fc.gsub!(regexp, ins_text)
  end
  File.open(filename, 'w') do |fc_out|
    fc_out.write(fc)
  end
end

def append_to_file(filename, ins_text, options = {})
  fc = IO.read filename
  if options[:force] or !fc.include?(ins_text)
    fc += ins_text
  end
  File.open(filename, 'w') do |fc_out|
    fc_out.write(fc)
  end
end

def append_to_env(ins_text, options = {})
  sub_in_file("config/environment.rb", /^end$/, "#{ins_text}end")
end

use_rest_auth = yes?("Use accounts with RESTful_Authentication [yes/no] ?")
use_activate = yes?("Require email activation of accounts [yes/no] ?")
#use_openid = yes?("Allow OpenID login? [yes/no]") if use_rest_auth

plugin 'juggernaut_plugin', :git => 'git://github.com/maccman/juggernaut_plugin.git'
plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git' if use_rest_auth

gem "daemons"
github_gem "maccman", "juggernaut"

# Uncomment only one of these lines
#github_gem "noahgibbs", "railsgame"
gem "railsgame"
#gem "noahgibbs-railsgame"  # assume already installed

# Uncomment to install gems
#rake("gems:install", :sudo => true)

run "rm public/index.html"
run "mv README RAILS_README"
generate(:rg_crypto_keys)
ENV['RG_RAILS_SESSION_SECRET'] = 'a' * 50  # Fake session secret

act_opts = []
act_opts = ["--include-activation"] if use_activate
generate(:authenticated, 'User', 'Session', *act_opts)

generate(:rg_scaffold, 'game')
generate(:rg_auth_users)
generate(:rg_game_server)

if use_rest_auth
  route "map.root :controller => 'game', :action => 'home'"
  route "map.signup '/signup', :controller => 'users', :action => 'new'"
  route "map.signup '/login', :controller => 'session', :action => 'new'"
  route "map.signup '/logout', :controller => 'session', :action => 'destroy'"
  if use_activate
    route "map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil"
    # add :user_observer to list of observers

    sub_in_file("config/environment.rb",
                /\# config.active_record.observers = (.*)$/,
		"config.active_record.observers = :user_observer",
		:force => true)
    # modify user_mailer model
    sub_in_file("app/models/user_mailer.rb",
		/http:\/\/YOURSITE\//, '#{ENV[\'RG_SITE_URL\']}/')
    sub_in_file("app/models/user_mailer.rb",
		/\"\[YOURSITE\] \"/, "ENV['RG_MAIL_PREFIX']")
    sub_in_file("app/models/user_mailer.rb",
		/\"ADMINEMAIL\"/, "ENV['RG_ADMIN_EMAIL']")
    sub_in_file("app/views/user_mailer/signup_notification.erb",
		/Password: (.*)$/,
		"Password: (not sent by email - that's insecure!)")

    append_to_env <<-END

  # Configure SMTP server for outgoing mail server
  config.action_mailer.smtp_settings = { :address => ENV['RG_SMTP_SERVER'],
    :port => ENV['RG_SMTP_PORT'], :domain => ENV['RG_SMTP_DOMAIN'],
    :user_name => ENV['RG_SMTP_USER'], :password => ENV['RG_SMTP_PASSWORD'],
    :authentication => :login }
END

  end  # if use_activate
  # TODO: add "include AuthenticatedSystem" to app controller
  # change site_keys to use env vars
  sub_in_file('config/initializers/site_keys.rb',
	      /REST_AUTH_SITE_KEY\s+=\s+'(.*)'$/,
	      "REST_AUTH_SITE_KEY = ENV['RG_REST_AUTH_SITE_KEY']")
  # modify session_store for env vars and to add middleware
  sub_in_file('config/initializers/session_store.rb',
              /:secret\s+=>\s+'(.*)'/,
	      ":secret => ENV['RG_RAILS_SESSION_SECRET']")

  sub_in_file('config/environment.rb',
	      /\#? config.load_paths\s+\+=\s+(.*)$/,
	      'config.load_paths += %W( #{RAILS_ROOT}/app/middleware )')
  append_to_file "config/initializers/session_store.rb", <<-END

ActionController::Dispatcher.middleware.insert_before(
  ActionController::Base.session_store,
  JuggernautSessionCookieMiddleware,
  ActionController::Base.session_options[:key])
END

  # TODO: add flash container to sessions view
end   # if use_rest_auth

sub_in_file('app/controllers/application_controller.rb',
	    /\# filter_parameter_logging :password/,
            "filter_parameter_logging :password", :force => true)
# modify juggernaut_hosts.yml
sub_in_file('config/juggernaut_hosts.yml',
	    /:port: 5001/,
	    ":port: <%= ENV['RG_JUGGERNAUT_PORT'] %>")
sub_in_file('config/juggernaut_hosts.yml',
	    /:host: 127.0.0.1/,
	    ":host: <%= ENV['RG_JUGGERNAUT_SERVER'] %>")
sub_in_file('config/juggernaut_hosts.yml',
	    /:public_/, "#:public_")

rake("db:migrate") # By default, this will be SQLite

file '.gitignore', <<-END
*~
#*#
log/*.log
log/*.pid
log/*.output
db/*.db
db/*.sqlite3
tmp/**/*
pkg/*
config/database.yml
crypto_keys.sh
private_variables.sh
END

file "TODO", <<-END
* Go through private_variables.sh and add my information

* In app/controllers/application_controller.rb:
  Uncomment "filter_parameter_logging :password"

* In app/models/user_mailer.rb and app/views/user_mailer/*.rb:
  Check phrasing of email stuff

* Set up your remote source repository (git?) and upload your project.
  Losing all your progress sucks, so don't do that!

* Add a license file, so it's clear to everybody what rights you reserve.
END

if yes?("Set up an initial Git repository [yes/no] ?")
  git :init
  git :add => "."
  git :commit => "-a -m 'Initial commit'"
end

print <<-END


Now you have a RailsGame ready to work on!  Please see the TODO file
for a list of stuff you could easily modify, or should fix up.  You'll
also need to set up private_variables.sh so that RailsGame has the
data it needs to do its job.

When you've set things like your game's name and URL in
private_variables.sh, type "run_server.sh" to start up your new
RailsGame!  It's (theoretically, eventually) just that easy!


END
