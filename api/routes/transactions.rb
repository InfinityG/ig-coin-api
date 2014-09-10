module Sinatra
  module TransactionRoutes

    def self.registered(app)

      app.post '/deposits' do
        data = JSON.parse(request.body.read)
        user_id = data['user_id']
        amount = data['amount']

        if user_id.to_s != '' && amount.to_i > 0
          #check this is a valid user
          user = UserService.new.get_by_id user_id

          if user != nil
            result = TransactionService.new.execute_deposit(user_id, amount)

            status 200 # not 201 as this has just been submitted.
            return {:success => result}
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

        if user_id.to_s != '' && amount.to_i > 0
          #check this is a valid user
          user = UserService.new.get_by_id user_id

          if user != nil
            result = TransactionService.new.execute_withdrawal(user_id, amount)

            status 200 # not 201 as this has just been submitted.
            {:status_url => result}.to_json
          end
          status 400

        end
        status 400
      end

    end
  end
  register TransactionRoutes
end