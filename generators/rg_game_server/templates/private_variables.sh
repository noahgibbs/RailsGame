# The site address is where your server can be found.  It might be
# something like freebeer.org or joesmith.myisp.com.
export RM_SITE_ADDRESS=railsgame.mydomain.com
export RM_SITE_PORT=4321
export RM_SITE_URL=http://$RM_SITE_ADDRESS:$RM_SITE_PORT
export RM_SITE_NAME="My Rails Game"

# Set up information for your outbound mail server.  You can probably
# find this information on your ISP's web site.  The username and password
# is usually the one for your ISP.  The domain is the one you want your
# outbound mail coming from.
#   If you've turned on email account activation and you get an error every
# time you try to send mail, you should probably check this and the admin
# email address to make sure both are correct.
export RM_SMTP_SERVER=smtp.myisp.com
export RM_SMTP_PORT=25
export RM_SMTP_DOMAIN=$RM_SITE_ADDRESS
export RM_SMTP_USER=joesmith
export RM_SMTP_PASSWORD='j03_707411Y_r0xx0rz'
export RM_MAIL_PREFIX='['$RM_SITE_NAME']'

# The admin name for the original admin account
export RM_ADMIN_NAME=joe_the_admin

# The 'customer service' address your users are told to use.
# This may need to be a valid email address without any 'nospam' stuff
# because some mail servers won't take email from fake domains.
export RM_ADMIN_EMAIL=joesmith@myisp.com

############# OPTIONAL SETTINGS ########################################
# Below this line, every setting is optional.  You may want to set some,
# but if you don't change them then things will still work fine.

# Choose 'development' or 'release'
# If you change this, change it in config/juggernaut_hosts as well!
export RM_RAILS_ENVIRONMENT=development

# Set to override which Rails version to use
#export RM_RAILS_VERSION=2.3.3

############# EXPERT SETTINGS ##########################################
# Please know a fair bit about the architecture of the server, how it works,
# and what you're doing with it before you change anything below this line.

# The port for the gameserver
export RM_GAMESERVER_HOST=localhost
export RM_GAMESERVER_PORT=6001

# Settings for the Juggernaut server, normally the same as the main
# game server
export RM_JUGGERNAUT_SERVER=$RM_SITE_ADDRESS
export RM_JUGGERNAUT_PORT=5001
