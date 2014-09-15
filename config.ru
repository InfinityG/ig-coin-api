#config.ru
# see http://bundler.io/v1.3/sinatra.html

# require 'rubygems'
# require 'bundler'

# Bundler.require

require 'logger'
require './app'

DEFAULT_USER_PASSWORD = '4mplyus3r'
DEFAULT_CURRENCY = 'PDC'
DEFAULT_TRUST_LIMIT = 5000

#gatewayd constants
GATEWAYD_URI = 'http://localhost:5000'  #running on a VM - use port forwarding
GATEWAYD_ADMIN_USER = 'admin@amply-gateway.com'
GATEWAYD_KEY = '20249b99af7478b727fab7006f2544ab6f57edbbe31e390a42e32bfe16b3e5a3'


GATEWAY_HOT_WALLET_ADDRESS = 'rBTzkpmkc3hz4sfYYksgBoWAruknZwexj4'
GATEWAY_HOT_WALLET_SECRET = ''
GATEWAY_COLD_WALLET_ADDRESS = 'rsuqshbN5DQ8dujGzUx4YiuZRcWzGJYSH4'

#customer wallet constants
CUSTOMER_WALLET_ADDRESS = 'rhED44GPmMc2nrHbicG6ya4TMx3rKpQZ2d'
CUSTOMER_WALLET_SECRET = ''

#ripple-rest constants
RIPPLE_REST_URI = 'http://localhost:5990' #running on a VM - use port forwarding

#logging
LOGGER = Logger.new 'app_log.log', 10, 1024000
DEFAULT_REQUEST_TIMEOUT = 60

#CORS origins
ALLOWED_ORIGIN = 'http://localhost:8001'

run ApiApp

# start this with 'rackup -p 8000' to start on port 8000