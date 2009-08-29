export RG_REST_AUTH_SITE_KEY=<%= ActiveSupport::SecureRandom.hex(30) %>
export RG_RAILS_SESSION_SECRET=<%= ActiveSupport::SecureRandom.hex(100) %>
export RG_JUGGER_GS_SESSION=<%= ActiveSupport::SecureRandom.hex(40) %>
