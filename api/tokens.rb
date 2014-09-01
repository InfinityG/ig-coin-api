require '../api/services/token_service'

class Tokens
#create new token: login
  post '/tokens' do
    'Create user login token'
    username = params[:username]
    password = params[:password]

    if username != nil && username != '' && password != nil && password != ''
      if TokenService.new.create_token username, password == nil
        halt 403, 'Unauthorized!'
      end
    else
      halt 403, 'Unauthorized!'
    end
  end
end