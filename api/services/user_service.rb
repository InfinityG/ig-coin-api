require './api/models/user'
require './api/utils/hash_generator'

class UserService
  def create(first_name, last_name, password, username)
    #create salt and hash
    hash_generator = HashGenerator.new
    salt = hash_generator.generate_salt
    hashed_password = hash_generator.generate_hash password, salt

    #create user on local db
    begin
      return save_user(first_name, last_name, username, hashed_password, salt)
    rescue
      LOGGER.error "Unable to save user #{username} on database! || Error: #{$!}"
      raise "Unable to save user #{username} on database! || Error: #{$!}"
    end
  end

  #TODO: refactor this to handle paging
  def get_all
    User.all
  end

  def get_by_id(user_id)
    User.all(:id => user_id).first
  end

  def get_by_username(username)
    User.all(:username => username).first
  end

  def update(username, first_name, last_name, password)
    #TODO: update the DB - username is the identifier and cannot be changed
    raise 'User update not implemented'
  end

  def delete(username)
    #TODO: delete from the DB - username is the identifier
    raise 'User delete not implemented'
  end

### HELPERS ###
  private
  def save_user(first_name, last_name, username, hashed_password, salt)
    user = User.new(:first_name => first_name,
                    :last_name => last_name,
                    :username => username,
                    :password_salt => salt,
                    :password_hash => hashed_password)

    user.save
    user
  end

end