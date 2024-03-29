require 'sinatra/base'
require 'data_mapper'
require 'dm-sqlite-adapter'
require './api/routes/users'
# require './api/routes/admin'
require './api/routes/cors'
require './api/routes/tokens'
require './api/routes/auth'
require './api/routes/transactions'
require './api/routes/config'

class ApiApp < Sinatra::Base

  #register routes
  #register Sinatra::AuthRoutes
  register Sinatra::CorsRoutes
  register Sinatra::ConfigRoutes
  register Sinatra::UserRoutes
  register Sinatra::TokenRoutes
  register Sinatra::TransactionRoutes

  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")
  DataMapper.finalize
  # DataMapper.auto_migrate!  #creates the tables on first use

end