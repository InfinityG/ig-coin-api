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
          return {:id => user[:id], :token => token[:uuid]}.to_json
        end

        status 400
      end

      #get user details
      app.get '/users/:user_id' do
        content_type :json

        user_id = params[:user_id]
        user_service = UserService.new
        user = user_service.get_by_id user_id
        user.to_json
      end

      #get user's transactions
      app.get '/users/:user_id/transactions' do

        user_id = params[:user_id]
        user_service = UserService.new
        user = user_service.get_by_id user_id

        if user != nil
          transaction_service = TransactionService.new
          result = transaction_service.get_transactions user_id

          trans_arr = []

          result.each { |item|
            trans_arr << {:id => item[:id], :user_id => item[:user_id], :amount => item[:amount],
                          :currency => item[:currency], :timestamp => item[:ledger_timestamp], :type => item[:type]}
          }

          return trans_arr.to_json

        else
          raise 'User cannot be found!'
        end

      end

      #get single user transaction
      app.get '/users/:user_id/transactions/:transaction_id' do
        user_service = UserService.new
        user = user_service.get_by_id params[:user_id]

        if user != nil
          transaction_service = TransactionService.new
          item = transaction_service.get_transaction_by_id params[:user_id], params[:transaction_id]
          response = {:id => item[:id], :user_id => item[:user_id], :amount => item[:amount],
                      :currency => item[:currency], :timestamp => item[:ledger_timestamp], :type => item[:type]}
          return response.to_json
        else
          raise 'User cannot be found!'
        end

      end

      #get user's balance
      app.get '/users/:user_id/balance' do
        user_id = params[:user_id]
        user_service = UserService.new
        user = user_service.get_by_id user_id

        if user != nil
          transaction_service = TransactionService.new
          result = transaction_service.get_transactions user_id

          balance = 0

          result.each { |item|
            item_amount = item[:amount].to_i
            item_type = item[:type]

            case item_type
              when 'deposit'
                balance += item_amount
              when 'withdrawal'
                balance -= item_amount
              else
                raise 'Unknown transaction type!'
            end

          }

          return {:user_id => user_id, :balance => balance, :currency => DEFAULT_CURRENCY}.to_json

        else
          raise 'User cannot be found!'
        end

      end

    end

  end
  register UserRoutes
end