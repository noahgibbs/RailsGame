# This is a Rails template to set up a new RailsGame project

def github_gem(user, gemname, options = {})
  base_opts = { :lib => gemname, :source => "http://gems.github.com" }
  base_opts.merge! options
  gem "#{user}-#{gemname}", base_opts
end

plugin 'juggernaut_plugin', :git => 'git://github.com/maccman/juggernaut_plugin.git'
plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'

gem "daemons"
github_gem "maccman", "juggernaut"

# Uncomment only one of these lines
#github_gem "noahgibbs", "railsgame"
gem "railsgame"
#gem "noahgibbs-railsgame"  # assume already installed

#rake("gems:install", :sudo => true)

run "rm public/index.html"
generate(:rg_crypto_keys)
ENV['RM_RAILS_SESSION_SECRET'] = 'a' * 50  # Fake session secret

generate(:rg_scaffold, 'game')
route "map.root :controller => 'game'"

#generate(:rg_game_server)

rake("db:migrate") # By default, this will be SQLite

file '.gitignore', <<-END
*~
#*#
log/*.log
log/*.pid
db/*.db
db/*.sqlite3
tmp/**/*
pkg/*
config/database.yml
crypto_keys.sh
private_variables.sh
END

#git :init
#git :add => "."
#git :commit => "-a -m 'Initial commit'"
