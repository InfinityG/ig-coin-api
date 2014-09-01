require '../../api/models/user'

class UserRepository

  def create(user: User)

  end

  def get(username)
    #TODO: connect to the DB and lookup the user and the hash
    user = User.new
    user.username = username
    user.password_hash = 'hash_erqerqewrqerqer423423'
    user
  end

  def update(user:User)
    #TODO: update the DB
    user
  end
end