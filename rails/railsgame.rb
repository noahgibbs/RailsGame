# This is a Rails template to set up a new RailsGame project

def github_gem(user, gemname)
  gem "#{user}-#{gemname}", :lib => gemname,
    :source => "http://gems.github.com"
end

plugin 'juggernaut_plugin', :git => 'git://github.com/maccman/juggernaut_plugin.git'
plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'

gem "daemons"
github_gem "noahgibbs", "railsgame"
github_gem "maccman", "juggernaut_gem"

rake("gems:install", :sudo => true)

run "rm public/index.html"
generate(:rg_crypto_keys)
route "map.root :controller => 'game'"
rake("db:migrate")

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
END

#git :init
#git :add => "."
#git :commit => "-a -m 'Initial commit'"
