class User
  def id=(value)
    @id = value
  end

  def id
    @id
  end

  def first_name=(value)
    @first_name = value
  end

  def first_name
    @first_name
  end

  def last_name=(value)
    @last_name = value
  end

  def last_name
    @last_name
  end

  def email=(value)
    @email = value
  end

  def email
    @email
  end

  def username=(value)
    @username = value
  end

  def username
    @username
  end

  def password_hash=(value)
    @password_hash = value
  end

  def password_hash
    @password_hash
  end

  def password_salt(value)
    @password_salt = value
  end

  def password_salt
    @password_salt
  end



end