require 'data_mapper'

class Transaction

  include DataMapper::Resource

  property :id, Serial, :key => true
  property :confirmation_url, String, :length => 500
  property :user_id, Integer
  property :resource_id, String
  property :ledger_id, Integer
  property :ledger_hash, String, :length => 100
  property :ledger_timestamp, String, :length => 100
  property :amount, Integer
  property :currency, String
  property :type, String
  property :status, String

end