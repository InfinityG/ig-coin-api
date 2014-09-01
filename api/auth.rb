require 'sinatra'
require '../api/services/token_service'

class Authorization < Sinatra::Base

  before do
    authorize env['HTTP_AUTHORIZATION']
  end

  def authorize(auth_header)
    if auth_header == nil || (TokenService.new.get_token auth_header == nil)
        generate_unauthorized
    end
  end

  def generate_unauthorized
    halt 403, 'Unauthorized!'
  end

end