require 'data_mapper'

class Token

  include DataMapper::Resource

  property :id, Serial, :key => false
  property :user_id, Integer
  property :uuid, String,  :key => true
  property :expires, Integer

end