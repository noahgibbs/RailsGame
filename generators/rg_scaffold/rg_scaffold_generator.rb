class RgScaffoldGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|
      m.directory "app/controllers"
      m.directory "app/views"
      m.directory "app/views/layouts"
      m.directory "app/views/#{file_name}"
      m.template 'controllers/game_controller.rb',
      		  "app/controllers/#{file_name}_controller.rb"
      m.file 'layouts/games.html.erb',
      		  "app/views/layouts/#{file_name}.html.erb"
      m.file 'views/home.html.erb',
      		  "app/views/#{file_name}/home.html.erb"
      m.file 'views/full.html.erb',
      		  "app/views/#{file_name}/full.html.erb"
      m.directory "public"
      m.directory "public/stylesheets"
      m.file 'railsgame.css', 'public/stylesheets/railsgame.css'
    end
  end

end
