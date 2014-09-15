require 'sinatra/base'

module Sinatra
  module CorsRoutes
    def self.registered(app)

      app.before do
        # if request.request_method == 'OPTIONS'
          # Needed for AngularJS
          response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
          response.headers['Access-Control-Allow-Origin'] = ALLOWED_ORIGIN

          # halt 200
        # end
      end
    end
  end
  register CorsRoutes
end
