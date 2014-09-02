require 'sinatra/base'
require './api/routes/auth'

module Sinatra
module AdminRoutes
  def self.registered(app)

    #create new admin token: login
    app.post '/admin/tokens' do
      'Create admin user login token'
    end

    #assign rewards to user
    app.post '/admin/users/:userId/rewards' do
      "Assign rewards to user #{params[:userId]}"
    end

    #get user rewards balance
    app.get '/admin/users/:userId/rewards' do
      "Get user rewards balance for #{params[:userId]}"
    end

    #get user redemption status
    app.get '/admin/users/{userId}/redemptions' do
      userId = params[:userId]
      # matches "GET /admin/users/{userId}/redemptions?status={status}"
      status = params[:status]
      "Get user redemption status for user #{userId} and status #{status}"
    end
  end
end
  register AdminRoutes
end