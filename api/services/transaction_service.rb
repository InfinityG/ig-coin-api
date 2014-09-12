require './api/gateway/ripple_rest_gateway'
require './api/utils/hash_generator'
require './api/models/transaction'

class TransactionService
  def execute_deposit(user, amount)
    ripple_gateway = RippleRestGateway.new
    client_resource_id = HashGenerator.new.generate_uuid
    payment = ripple_gateway.prepare_deposit user[:id].to_s, amount
    status_url = ripple_gateway.create_deposit(client_resource_id, payment)

    sleep 5 #TODO: break this out into a separate process

    confirmation_result = ripple_gateway.confirm_transaction "#{RIPPLE_REST_URI}#{status_url}"
    save_transaction user, confirmation_result, client_resource_id, 'deposit'

  end

  def execute_withdrawal(user, amount)
    ripple_gateway = RippleRestGateway.new
    client_resource_id = HashGenerator.new.generate_uuid
    payment = ripple_gateway.prepare_withdrawal user[:id].to_s, amount
    status_url = ripple_gateway.create_withdrawal(client_resource_id, payment)

    sleep 5

    confirmation_result = ripple_gateway.confirm_transaction "#{RIPPLE_REST_URI}#{status_url}"
    save_transaction user, confirmation_result, client_resource_id, 'withdrawal'

  end

  def get_transactions(user_id)
    Transaction.all(:user_id => user_id)
    end

  def get_transaction_by_id(user_id, transaction_id)
    Transaction.all(:id => transaction_id, :user_id => user_id).first
  end

  private
  def save_transaction(user, confirmation_result, resource_id, type)
    transaction = Transaction.new(:user_id => user.id,
                                  :resource_id => resource_id,
                                  :ledger_id => confirmation_result[:ledger_id],
                                  :ledger_hash => confirmation_result[:ledger_hash],
                                  :ledger_timestamp => confirmation_result[:ledger_timestamp],
                                  :amount => confirmation_result[:amount],
                                  :currency => confirmation_result[:currency],
                                  :type => type, :status => confirmation_result[:status])

    if transaction.save
      transaction
    else
      transaction.errors.each do |e|
        puts e
      end
      raise 'Error saving transaction!'
    end

  end

end