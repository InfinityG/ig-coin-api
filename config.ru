#config.ru
# see http://bundler.io/v1.3/sinatra.html

# require 'rubygems'
# require 'bundler'

# Bundler.require

require './app'

GATEWAYD_URI = 'http://amply-gateway.com:5000'
GATEWAYD_USER = 'admin@amply-gateway.com'
GATEWAYD_RIPPLE_ADDRESS = 'rBTzkpmkc3hz4sfYYksgBoWAruknZwexj4'  #hot wallet
GATEWAYD_KEY = '20249b99af7478b727fab7006f2544ab6f57edbbe31e390a42e32bfe16b3e5a3'

DEFAULT_USER_PASSWORD = '4mplyus3r'

run ApiApp

#YWRtaW5AYW1wbHktZ2F0ZXdheS5jb206MjAyNDliOTlhZjc0NzhiNzI3ZmFiNzAwNmYyNTQ0YWI2ZjU3ZWRiYmUzMWUzOTBhNDJlMzJiZmUxNmIzZTVhMw==