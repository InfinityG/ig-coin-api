require './api/models/user'
require './api/models/token'

class TokenRepository
  def create(user_id, uuid, timestamp)
    # TODO: save the token in the DB
    token = Token(Token.new)
    token.user_id = user_id
    token.uuid = uuid
    token.expires = timestamp
    token
  end

  def get (uuid)
    #TODO: get the token from the DB - this is a dummy
    token = Token.new
    token.uuid = uuid
    token.expires = (Time.now. + (60 * 60)).to_i
    token
  end

  def delete(id)
    #TODO: delete the token from the DB
    true
  end
end