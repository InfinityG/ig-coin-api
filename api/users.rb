require 'sinatra'
require_relative '../api/auth'

# class Users < Sinatra::Base
  #create new user: register
  post '/users' do
    'Register new user'
  end

#create new token: login
  post '/tokens' do
    'Create user login token'
  end

#get user details
  get '/users/:userId' do
    "Get user details for #{params[:userId]}"
  end

#get user's rewards
  get '/users/:userId/rewards' do
    "Get users rewards for #{params[:userId]}"
  end

#get user's rewards balance
  get '/users/:userId/rewards/balance' do
    "Get users rewards balance for #{params[:userId]}"
  end

# end