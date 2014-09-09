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
  property :gatewayd_external_account_id, Integer
  property :gatewayd_tag, Integer
  property :wallet_address, String
  property :wallet_secret, String

end