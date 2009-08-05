export RM_REST_AUTH_SITE_KEY=<%= ActiveSupport::SecureRandom.base64(30) %>
export RM_RAILS_SESSION_SECRET=<%= ActiveSupport::SecureRandom.base64(100) %>
export RM_JUGGER_GS_SESSION=<%= ActiveSupport::SecureRandom.base64(40) %>
