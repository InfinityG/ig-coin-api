require './api/models/user'
require './api/gateway/ripple_gateway'
require './api/utils/hash_generator'

class UserService
  def create(first_name, last_name, password, username)
    ripple_gateway = RippleGateway.new

    #-save the address and secret for the user (secret required for future withdrawals); need to investigate encryption
    #-use the new address in the register_user step below.
    wallet_result = nil
    wallet_address = nil
    wallet_secret = nil

    begin
      wallet_result = ripple_gateway.create_wallet
      wallet_address = wallet_result[:address]
      wallet_secret = wallet_result[:secret]
    rescue
      LOGGER.error $!
      raise "Unable to create wallet for user #{username}!"
    end

    #Create the user on gatewayd, and get the gateway's user id and tag
    register_result = nil
    g_user_id = nil
    g_tag = nil
    g_ext_account_id = nil

    begin
      register_result = ripple_gateway.register_user username, password, wallet_address
      g_user_id = register_result[:user_id]
      g_tag = register_result[:tag]
      g_ext_account_id = register_result[:external_account_id]
    rescue
      LOGGER.error "Unable to register user on gatewayd for [#{username} | #{wallet_address} | #{wallet_secret}] || Error: #{$!}"
      raise "Unable to register user on gatewayd for [#{username} | #{wallet_address} | #{wallet_secret}]"
    end

    begin
      #set a trustline between the new user wallet and gatewayd
      ripple_gateway.create_trust_line(wallet_address, wallet_secret, DEFAULT_TRUST_LIMIT, DEFAULT_CURRENCY, GATEWAYD_HOT_ADDRESS)
    rescue
      LOGGER.error "Unable to create trust line! || Error: #{$!}"
    end

    #create salt and hash
    hash_generator = HashGenerator.new
    salt = hash_generator.generate_salt
    hashed_password = hash_generator.generate_hash password, salt

    user_result = nil

    begin
      #create user on local db
      user_result = save_user(first_name, last_name, username, hashed_password, salt, g_tag, g_user_id,
                              g_ext_account_id, wallet_address, wallet_secret)
    rescue
      LOGGER.error "Unable to save user on database! [#{username} | #{wallet_address} | #{wallet_secret}] || Error: #{$!}"
      raise "Unable to save user on database! [#{username} | #{wallet_address} | #{wallet_secret} || Error: #{$!}]"
    end

    user_result
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

### HELPERS ###
  private
  def save_user(first_name, last_name, username, hashed_password, salt, g_tag, g_user_id, g_ext_account_id, wallet_address, wallet_secret)
    user = User.new(:first_name => first_name,
                    :last_name => last_name,
                    :username => username,
                    :password_salt => salt,
                    :password_hash => hashed_password,
                    :gatewayd_user_id => g_user_id,
                    :gatewayd_tag => g_tag,
                    :gatewayd_external_account_id => g_ext_account_id,
                    :wallet_address => wallet_address,
                    :wallet_secret => wallet_secret)

    user.save
    user
  end

end