require './api/models/user'

class UserRepository

  def create(first_name, last_name, password, username)
      hash_generator = HashGenerator.new
      salt = hash_generator.generate_salt
      hashed_password = hash_generator.generate_hash password, salt

      user = User.new(:first_name => first_name,
                      :last_name => last_name,
                      :username => username,
                      :password_salt => salt,
                      :password_hash => hashed_password)

      user.save
      user
  end

  def get(username)
    User.get username
  end

  def update(user:User)
    #TODO: update the DB
    user
  end
end