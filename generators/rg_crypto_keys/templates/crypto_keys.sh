export RM_REST_AUTH_SITE_KEY=<%= ActiveSupport::SecureRandom.hex(30) %>
export RM_RAILS_SESSION_SECRET=<%= ActiveSupport::SecureRandom.hex(100) %>
export RM_JUGGER_GS_SESSION=<%= ActiveSupport::SecureRandom.hex(40) %>
