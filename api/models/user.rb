require 'data_mapper'

class User
  include DataMapper::Resource

  property :id, Serial, :required => false
  property :first_name, String, :required => true
  property :last_name, String, :required => true
  property :username, String, :required => true, :key => true
  property :password_hash, String
  property :password_salt, String
  property :gatewayd_user_id, String

end