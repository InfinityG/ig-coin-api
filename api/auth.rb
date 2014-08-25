require 'sinatra'

# class Authorization < Sinatra::Base

  before do
    authorize env['HTTP_AUTHORIZATION']
  end

  def authorize(auth_header)
    #some logic here to check the header is correct against the DB
   if auth_header == nil
     halt 403, 'Unauthorized!'
   end
  end

# end