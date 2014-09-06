
require './api/utils/hash_generator'
require './api/models/user'
require './api/models/token'
require 'securerandom'
require 'data_mapper'

class TokenService

  def create_token(username, password)

    #get the user first and check if the password matches
    user = UserService.new.get_by_username username

    if user != nil
      password_salt = user['password_salt']
      password_hash = user['password_hash']

      #now check if the hash matches the password
      result = HashGenerator.new.generate_hash password, password_salt

      if result == password_hash
        #all good, now save the token for the user
        uuid = SecureRandom.uuid
        save_token user.id, uuid
        return uuid
      end

      return nil
    end

    nil
  end

  def get_token(uuid)
    token = Token.get(uuid)

    #check that the token hasn't expired, if it has, delete it
    if token != nil
      if token.expires <= Time.now.to_i
        token.destroy
        return nil
      end
    end

    nil
  end

  private
  def save_token(user_id, token)
    timestamp = Time.now
    expires = timestamp + (60 * 60)

    token = Token.new(:user_id => user_id, :uuid => token, :expires => expires.to_i)
    token.save
  end
end