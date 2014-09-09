#config.ru
# see http://bundler.io/v1.3/sinatra.html

# require 'rubygems'
# require 'bundler'

# Bundler.require

require './app'

DEFAULT_USER_PASSWORD = '4mplyus3r'
DEFAULT_CURRENCY = 'RWD'

#gatewayd constants
GATEWAYD_URI = 'http://amply-gateway.com:5000'
GATEWAYD_ADMIN_USER = 'admin@amply-gateway.com'
GATEWAYD_KEY = '20249b99af7478b727fab7006f2544ab6f57edbbe31e390a42e32bfe16b3e5a3'
GATEWAYD_HOT_ADDRESS = 'rBTzkpmkc3hz4sfYYksgBoWAruknZwexj4'
GATEWAYD_COLD_ADDRESS = 'rsuqshbN5DQ8dujGzUx4YiuZRcWzGJYSH4'

#ripple-rest constants
RIPPLE_REST_URI = 'http://amply-gateway.com:5990'

run ApiApp

#YWRtaW5AYW1wbHktZ2F0ZXdheS5jb206MjAyNDliOTlhZjc0NzhiNzI3ZmFiNzAwNmYyNTQ0YWI2ZjU3ZWRiYmUzMWUzOTBhNDJlMzJiZmUxNmIzZTVhMw==