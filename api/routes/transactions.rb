require './api/services/transaction_service'
require './api/services/user_service'
require 'json'

module Sinatra
  module TransactionRoutes

    def self.registered(app)

      app.post '/deposits' do
        data = JSON.parse(request.body.read)
        user_id = data['user_id']
        amount = data['amount']
        memo = data['memo']

        if user_id.to_s != '' && amount.to_i > 0
          #check this is a valid user
          user = UserService.new.get_by_id user_id

          if user != nil
            result = TransactionService.new.execute_deposit(user, amount, memo)

            status 200 # not 201 as this has just been submitted.
            return {:transaction_id => result[:id]}.to_json
          end
          status 400

        end
        status 400
      end

      # withdrawals effectively send currency from the user's wallet back to the gateway.
      # this is used for 'redeeming' rewards
      app.post '/withdrawals' do
        data = JSON.parse(request.body.read)
        user_id = data['user_id']
        amount = data['amount']
        memo = data['memo']

        if user_id.to_s != '' && amount.to_i > 0
          #check this is a valid user
          user = UserService.new.get_by_id user_id

          if user != nil
            result = TransactionService.new.execute_withdrawal(user, amount, memo)

            status 200 # not 201 as this has just been submitted.
            return {:transaction_id => result[:id]}.to_json
          end
          status 400

        end
        status 400
      end

    end
  end
  register TransactionRoutes
end