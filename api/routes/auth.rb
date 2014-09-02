require 'sinatra/base'
require './api/services/token_service'

module Sinatra
  module AuthRoutes
    def self.registered(app)

      #this filter applies to everything except registration of new users
      app.before do
        unless request.request_method == 'POST' && request.path_info == '/users'
          auth_header = env['HTTP_AUTHORIZATION']

          if auth_header == nil || (TokenService.new.get_token(auth_header) == nil)
            halt 403, 'Unauthorized!'
          end
        end
      end

    end
  end
  register AuthRoutes
end