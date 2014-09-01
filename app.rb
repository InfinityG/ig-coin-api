require 'sinatra/base'
require_relative './api/users'
require_relative './api/admin'

class ApiApp < Sinatra::Base
  use Users
  use Admin

  run! if app_file == $0
end