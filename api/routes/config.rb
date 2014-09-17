require './api/services/config_service'
require 'json'

module Sinatra
  module ConfigRoutes
    def self.registered(app)

      app.get '/config' do
        content_type :json

        config_service = ConfigurationService.new
        config_service.get_config.to_json

      end

    end
  end
  register ConfigRoutes
end