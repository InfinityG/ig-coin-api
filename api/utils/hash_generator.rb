require 'securerandom'
require 'digest'

class HashGenerator

  def generate(password, salt)
    salted_password = password + salt
    Digest::SHA2.base64digest salted_password
  end
end