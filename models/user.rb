require_relative '../models/model'

class User < Model
  attr_accessor :id, :username, :email, :bio

  def initialize(id=nil, username:, email:, bio:)
    @id = id,
    @username = username,
    @email = email,
    @bio = bio
  end

  def save
    unless @username.nil? and @email.nil?
      User.client.query("INSERT INTO users(username, email, bio) VALUES ('#{username}','#{email}','#{bio}')")
      return true
    end

    return false
  end
end
