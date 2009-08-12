class RgScaffoldGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|
      #m.template 'controller/game_controller.rb',
      #		  "app/controllers/#{file_name}_controller.rb"
      #m.template 'view/game/home.rb',
      #		  "app/views/#{file_name}/home.rb"
      #m.template 'view/game/full.rb',
      #		  "app/views/#{file_name}/full.rb"
    end
  end

end
