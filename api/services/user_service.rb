require './api/models/user'
require './api/gateway/ripple_gateway'
require './api/utils/hash_generator'

class UserService
  def create(first_name, last_name, password, username)

    #create salt and hash
    hash_generator = HashGenerator.new
    salt = hash_generator.generate_salt
    hashed_password = hash_generator.generate_hash password, salt

    #create user on local db
    user = User.new(:first_name => first_name,
                    :last_name => last_name,
                    :username => username,
                    :password_salt => salt,
                    :password_hash => hashed_password)

    user.save

    #now save the user on gatewayd, and get the gateway's user id
    ripple_gateway = RippleGateway.new
    gateway_user_id = ripple_gateway.register_user user[:id], user[:username]

    #now update the user on local db with the gatewayd user_id
    user.update(:gateway_user_id => gateway_user_id)

    user
  end

  def get_by_id(user_id)
    User.get(:id => user_id)
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
end