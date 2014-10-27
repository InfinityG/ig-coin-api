require './api/gateway/ripple_rest_gateway'
require './api/utils/hash_generator'
require './api/repositories/transaction_repository'

class TransactionService

  def execute_deposit(user, amount, memo)
    ripple_gateway = RippleRestGateway.new
    client_resource_id = HashGenerator.new.generate_uuid
    payment = ripple_gateway.prepare_deposit user[:id].to_s, amount, memo
    status_url = ripple_gateway.create_deposit(client_resource_id, payment)

    transaction_repository = TransactionRepository.new
    transaction_repository.save_transaction user[:id].to_s, client_resource_id, 'deposit', amount,
                                         DEFAULT_CURRENCY, "#{RIPPLE_REST_URI}#{status_url}"

  end

  def execute_withdrawal(user, amount, memo)
    ripple_gateway = RippleRestGateway.new
    client_resource_id = HashGenerator.new.generate_uuid
    payment = ripple_gateway.prepare_withdrawal user[:id].to_s, amount, memo
    status_url = ripple_gateway.create_withdrawal(client_resource_id, payment)

    transaction_repository = TransactionRepository.new
    transaction_repository.save_transaction user[:id].to_s, client_resource_id, 'withdrawal', amount,
                                         DEFAULT_CURRENCY, "#{RIPPLE_REST_URI}#{status_url}"
  end

  def get_transactions(user_id)
    repository = TransactionRepository.new
    repository.get_transactions(user_id)
    end

  def get_transaction(transaction_id, user_id = nil)
    repository = TransactionRepository.new

    if user_id == nil
      repository.get_transaction(transaction_id)
    else
      repository.get_transaction_by_user_id(user_id, transaction_id)
    end
  end

  def get_pending_transactions
    repository = TransactionRepository.new
    repository.get_transactions_by_status 'pending'
  end

  def save_transaction(user_id, resource_id, type, amount, currency, confirmation_url)
    repository = TransactionRepository.new
    repository.save_transaction user_id, resource_id, type, amount, currency, confirmation_url
  end

  def confirm_transaction(transaction_id, confirmation_result)
    repository = TransactionRepository.new
    repository.confirm_transaction transaction_id, confirmation_result
  end

end