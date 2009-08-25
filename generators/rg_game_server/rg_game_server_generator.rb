class RgGameServerGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.file 'run_server.sh', 'run_server.sh'
      m.file 'private_variables.sh', 'private_variables.sh'
      m.file 'rails_control.rb', 'rails_control.rb'
      m.file 'juggernaut_control.rb', 'juggernaut_control.rb'
      m.file 'juggernaut.yml', 'juggernaut.yml'
      m.directory 'config'
      m.directory 'game'
      m.file 'server.rb', "game/server.rb"
      m.file 'player.rb', "game/player.rb"
      m.file 'start_location.rb', "game/start_location.rb"
      m.file 'actions.rb', "game/actions.rb"
      m.file 'gameREADME', "game/README"
      m.file 'DEBUGGING', "DEBUGGING"
      m.readme 'README'
    end
  end

end
