require 'rack/utils'

class JuggernautSessionCookieMiddleware
  def initialize(app, session_key = '_session_id')
    @app = app
    @session_key = session_key
  end

  def call(env)
    params = {}
    if env['HTTP_USER_AGENT'] =~ /^Ruby\//
      req = Rack::Request.new(env)
      env['HTTP_COOKIE'] = [ @session_key, req.params['session_id'] ].join('=').freeze unless req.params['session_id'].nil? || req.params['client_id'] == 'gameserver'
    end
    @app.call(env)
  end
end
