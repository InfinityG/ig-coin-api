require 'rest_client'

class RestUtil

  def execute_get(api_uri)
    puts "Uri: #{api_uri}"

    client = get_client api_uri
    response = client.get(:content-type => 'application/json;charset=UTF-8', :verify_ssl => false)

    build_response(response)
  end

  def execute_post(api_uri, json)
    puts "Uri: #{api_uri}"
    puts "Json: #{json}"

    client = get_client api_uri
    response = client.post(json, :content_type => 'application/json;charset=UTF-8', :verify_ssl => false)

    build_response(response)
  end

  def build_response(response)
    rest_response = RestResponse.new
    rest_response.response_code = response.code
    rest_response.response_body = response.body
    rest_response
  end

  def get_client(uri)
    RestClient::Resource.new(uri, GATEWAYD_USER, GATEWAYD_KEY)
  end

end

class RestResponse
  attr_accessor :response_code
  attr_accessor :response_body
end