require 'sinatra/base'
require 'data_mapper'
require './api/routes/auth'
require './api/services/user_service'
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

          user_service = UserService.new

          #return conflict error if user already exists (username check)
          existing_user = user_service.get_by_username username
          return status 409 if existing_user != nil

          #create new user
          user = user_service.create(first_name, last_name, password, username)
          puts user.to_json

          #create an auth token for initial login
          token = TokenService.new.create_token_for_registration user[:id]

          #final result is simply the user id and the initial auth token
          status 201
          {:id => user[:id], :token => token}.to_json
        end

        status 400
      end

      #get user details
      app.get '/users/:user_id' do
        content_type :json

        user_id =  params[:user_id]
        user_repository = UserService.new
        user = user_repository.get_by_id user_id
        user.to_json
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