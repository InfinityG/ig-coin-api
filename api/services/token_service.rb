require '../../api/repositories/token_repository'
require '../../api/repositories/user_repository'
require '../utils/hash_generator'
require 'securerandom'

class TokenService
  def create_token(username, password)

      #get the user first and check if the password matches
      user_repo = UserRepository.new
      user = User(user_repo.get username)

      if user != nil && user.username == username
        password_salt = user.password_salt
        password_hash = user.password_hash

        #now check if the hash matches the password
        result = HashGenerator.new.generate password, password_salt

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
    repo = TokenRepository.new
    token = Token(repo.get(uuid))

    #check that the token hasn't expired, if it has, delete it
    if token.expires <= Time.now.to_i
       repo.delete token.id
       return nil
    end

    token
  end

  private
  def save_token(user_id, token)
    timestamp = Time.now
    expires = timestamp + 1.hour
    TokenRepository.new.create user_id, token, expires.to_i
  end
end