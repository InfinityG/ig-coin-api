require 'securerandom'
require 'digest'

class HashGenerator

  def generate_hash(password, salt)
    salted_password = password + salt
    Digest::SHA2.base64digest salted_password
  end

  def generate_salt
    SecureRandom.uuid
  end
end