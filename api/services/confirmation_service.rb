require 'bunny'
require 'json'
require './api/gateway/ripple_rest_gateway'
require './api/services/transaction_service'

class ConfirmationService

  # this will start a new thread which will periodically retrieve pending
  # transactions from the DB and attempt to validate them
  def start
    @service_thread = Thread.new {

      gateway = RippleRestGateway.new
      transaction_service = TransactionService.new

      while true
        pending_transactions = transaction_service.get_pending_transactions

        pending_transactions.each { |transaction|
          confirmation_url = transaction[:confirmation_url]
          result = gateway.confirm_transaction confirmation_url

          if result[:status] == 'validated'
            transaction_service.confirm_transaction transaction[:id], result
          end
        }

        sleep 5.0

      end

    }
  end

end