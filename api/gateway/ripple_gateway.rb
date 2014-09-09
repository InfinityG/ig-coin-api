require './api/utils/rest_util'
require './api/utils/key_provider'
require 'json'

class RippleGateway

  #for DI
  # def initialize(rest_util, config_util)
  #   @rest_util = rest_util
  #   @config_util = config_util
  # end

  private
  def rest_util_instance
    @rest_util = RestUtil.new if @rest_util == nil
    @rest_util
  end

  def create_wallet
    uri = "#{GATEWAYD_URI}/v1/wallets/generate"
    result = rest_util_instance.execute_post uri

    validate_result result, 'Generate wallet'

    json = JSON.parse(result.response_body)
    {:address => json['wallet']['address'], :secret => json['wallet']['secret']}
  end

  def register_user(user_name, password, ripple_address)
    #user_uri = "#{GATEWAYD_URI}/v1/users"
    uri = "#{GATEWAYD_URI}/v1/register"

    #create user on gatewayd
    payload = {:name => user_name, :password => password, :ripple_address => ripple_address}.to_json
    result = rest_util_instance.execute_post uri, payload

    validate_result result, 'Create user'

    json = JSON.parse result.response_body
    id = json['user']['id']
    tag = json['user']['hosted_address']['tag']
    external_account_id = json['user']['external_account']['id']

    {:user_id => id, :tag => tag, :external_account_id => external_account_id}
  end

  def create_trust_line(ripple_address, ripple_secret, limit, currency, counterparty_address)
    uri = "#{RIPPLE_REST_URI}/v1/accounts/#{ripple_address}/trustlines"
    payload = {:secret => ripple_secret,
                          :trustline => {:limit => limit,
                                         :currency => currency,
                                         :counterparty => counterparty_address,
                                         :allows_rippling => false}}

    result = rest_util_instance.execute_post uri, payload

    validate_result result, 'Create trustline'

    json = JSON.parse result.response_body
    json['success']
  end

  def create_deposit(user, amount)
    g_ext_account_id = user[:gateway_external_account_id]

    uri = "#{GATEWAYD_URI}/v1/deposits"
    payload = {:external_account_id => g_ext_account_id, :currency => DEFAULT_CURRENCY, :amount => amount}

    result = rest_util_instance.execute_post uri, payload

    validate_result result, 'Create deposit'

    json = JSON.parse result.response_body
    json['deposit']['status']
  end

  def create_withdrawal(user, amount)
    source_address = user[:wallet_address]
    prepared_payment = prepare_payment source_address, amount

    if prepared_payment[:success]
      payment = prepared_payment[:payments][0]
      secret = user[:wallet_secret]
      client_resource_id = HashGenerator.new.generate_uuid

      uri = "#{RIPPLE_REST_URI}/v1/payments"
      payload = {:secret => secret, :client_resource_id => client_resource_id, :payment => payment}

      result = rest_util_instance.execute_post uri, payload

      validate_result result, 'Create withdrawal'

      json = JSON.parse result.response_body

      unless json['success']
        json['message']
      end
      json['status_url']
    else
      raise 'Unsuccessful payment preparation!'
    end

  end

  ### HELPERS ####

  private
  def prepare_payment(source_address, amount)
    destination_amount = "#{amount}+#{DEFAULT_CURRENCY}+#{GATEWAYD_HOT_ADDRESS}"
    uri = "#{RIPPLE_REST_URI}/v1/accounts/#{source_address}/payments/paths/#{GATEWAYD_HOT_ADDRESS}/#{destination_amount}"

    rest_util_instance.execute_get uri
  end

  private
  def validate_result(result, method_name)
    if result.response_code != 200 && result.response_code != 201
      raise "#{method_name} failed!"
    end
  end

end