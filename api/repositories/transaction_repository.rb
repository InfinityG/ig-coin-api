require './api/models/transaction'

class TransactionRepository
  def get_transactions(user_id)
    Transaction.all(:user_id => user_id)
  end

  def get_transaction(transaction_id)
    Transaction.all(:id => transaction_id).first
  end

  def get_transaction_by_user_id(user_id, transaction_id)
    Transaction.all(:id => transaction_id, :user_id => user_id).first
  end

  def get_transactions_by_status(status)
    Transaction.all(:status => status)
  end

  def save_transaction(user_id, resource_id, type, amount, currency, confirmation_url)
    transaction = Transaction.new(:user_id => user_id,
                                  :resource_id => resource_id,
                                  :amount => amount,
                                  :currency => currency,
                                  :type => type,
                                  :status => 'pending',
                                  :confirmation_url => confirmation_url)

    if transaction.save
      transaction
    else
      transaction.errors.each do |e|
        puts e
      end
      raise 'Error saving transaction!'
    end

    end

  def confirm_transaction(transaction_id, confirmation_result)
    transaction = get_transaction transaction_id

    if transaction.update(:ledger_id => confirmation_result[:ledger_id],
                          :ledger_hash => confirmation_result[:ledger_hash],
                          :ledger_timestamp => confirmation_result[:ledger_timestamp],
                          :amount => confirmation_result[:amount],
                          :currency => confirmation_result[:currency],
                          :status => confirmation_result[:status])
      transaction
    else
      transaction.errors.each do |e|
        puts e
      end
      raise 'Error confirming transaction!'
    end

    end
end