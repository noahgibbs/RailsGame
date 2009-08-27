class RgAuthUsersGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory "app/middleware"
      m.file "juggernaut_session_cookie_middleware.rb",
        "app/middleware/juggernaut_session_cookie_middleware.rb"
      m.directory "app/views/layouts"
      m.file "sessions.html.erb", "app/views/layouts/sessions.html.erb"
      #m.template 'controllers/game_controller.rb',
      #		  "app/controllers/#{file_name}_controller.rb"
    end
  end

end
