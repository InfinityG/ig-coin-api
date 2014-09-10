require 'sinatra/base'
require 'data_mapper'
require 'dm-sqlite-adapter'
require './api/routes/users'
# require './api/routes/admin'
require './api/routes/tokens'
require './api/routes/auth'
require './api/routes/transactions'

class ApiApp < Sinatra::Base

  #register routes
  register Sinatra::AuthRoutes
  # register Sinatra::AdminRoutes
  register Sinatra::UserRoutes
  register Sinatra::TokenRoutes
  register Sinatra::TransactionRoutes

  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")
  DataMapper.finalize

end