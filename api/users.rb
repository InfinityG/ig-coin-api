require 'sinatra'
require_relative '../api/auth'

 class Users < Authorization
  #create new user: register
  post '/users' do
    'Register new user'
  end



#get user details
  get '/users/:userId' do
    "Get user details for ` `#{params[:userId]}"
  end

#get user's rewards
  get '/users/:userId/rewards' do
    "Get users rewards for #{params[:userId]}"
  end

#get user's rewards balance
  get '/users/:userId/rewards/balance' do
    "Get users rewards balance for #{params[:userId]}"
  end

 end