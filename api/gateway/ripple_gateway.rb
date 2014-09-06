require './api/utils/rest_util'
require './api/utils/key_provider'
require 'json'

class RippleGateway

  #for DI
  # def initialize(rest_util, config_util)
  #   @rest_util = rest_util
  #   @config_util = config_util
  # end

  def register_user(tag, user_name)
    rest_util = RestUtil.new

    user_uri = "#{GATEWAYD_URI}/v1/users"

    #create user on gatewayd
    user_payload = {:name => user_name, :password => DEFAULT_USER_PASSWORD}.to_json
    user_result = rest_util.execute_post(user_uri, user_payload)

    validate_result user_result

    user_json = JSON.parse(user_result.response_body)
    u_id = user_json['user']['id']

    #now update the Ripple addresses so that the user has the correct tag
    #TODO: this resource cannot be found!
    address_uri = "#{GATEWAYD_URI}/v1/users/#{u_id}/ripple_addresses"
    address_payload = {:user_id => u_id, :address => GATEWAYD_RIPPLE_ADDRESS, :tag => tag}.to_json
    address_result = rest_util.execute_post(address_uri, address_payload)

    #validate_result address_result

    address_result.response_body

    #return user_id from gatewayd
    u_id
  end
  def validate_result(result)
    if result.response_code != 200 && result.response_code != 201
      raise 'Ripple address update for user failed!'
    end
  end

end