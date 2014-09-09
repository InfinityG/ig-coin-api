require '../../api/services/user_service'

class TransactionService
  def execute_deposit(user_id, amount)
    # this is effectively a 'deposit' - although we are not receiving any physical
    # assets from the user, we will still issue a deposit request. This effectively means that
    # the gateway will issue currency to the user's address, with the expectation that this will
    # be 'withdrawn' or 'redeemed' at a later stage.

    user_service = UserService.new
    user = user_service.get_by_id user_id

    g_ext_account_id = user[:gateway_external_account_id]

    ripple_gateway = RippleGateway.new
    ripple_gateway.create_deposit(g_ext_account_id, DEFAULT_CURRENCY, amount)

  end

  def execute_withdrawal(user_id, amount)
    user_service = UserService.new
    user = user_service.get_by_id user_id

    ripple_gateway = RippleGateway.new
    ripple_gateway.create_withdrawal(user, amount)
  end
end