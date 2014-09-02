require 'sinatra/base'
require 'data_mapper'
require './api/routes/auth'
require './api/utils/hash_generator'

module Sinatra
  module UserRoutes
    def self.registered(app)

      app.post '/users' do
        content_type :json

        data = JSON.parse(request.body.read)
        first_name = data['first_name']
        last_name = data['last_name']
        username = data['username']
        password = data['password']

        if first_name.to_s != '' && last_name.to_s != '' && username.to_s != '' && password.to_s != ''

          user_repository = UserRepository.new

          #return conflict error if user already exists
          existing_user = user_repository.get username
          return status 409 if existing_user != nil

          #create new user
          user = user_repository.create(first_name, last_name, password, username)
          status 201
          return user.to_json
        end

        status 400
      end

      #get user details
      app.get '/users/:userId' do
        content_type :json
        "Get user details for ` `#{params[:userId]}"
      end

      #get user's rewards
      app.get '/users/:userId/rewards' do
        "Get users rewards for #{params[:userId]}"
      end

      #get user's rewards balance
      app.get '/users/:userId/rewards/balance' do
        "Get users rewards balance for #{params[:userId]}"
      end
    end


  end
  register UserRoutes
end