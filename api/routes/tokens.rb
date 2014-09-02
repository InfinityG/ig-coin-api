require 'sinatra/base'
require './api/services/token_service'
require 'json'


module Sinatra
  module TokenRoutes
    def self.registered(app)

    #create new token: login
    app.post '/tokens' do
      data = JSON.parse(request.body.read)

      username = data['username']
      password = data['password']

      if username != nil && username != '' && password != nil && password != ''
        token = TokenService.new.create_token username, password

        if token == nil
          halt 403, 'Unauthorized!'
        end

        token.to_json

      else
        halt 403, 'Unauthorized!'
      end
    end

  end
  end
  register TokenRoutes
  end