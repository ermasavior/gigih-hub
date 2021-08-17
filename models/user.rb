require_relative '../models/model'

class User < Model
  attr_accessor :id, :username, :email, :bio

  def initialize(id=nil, username:, email:, bio:)
    @id = id
    @username = username
    @email = email
    @bio = bio
  end

  def save
    return false if @username.nil? or @email.nil?

    User.client.query("INSERT INTO users(username, email, bio) VALUES ('#{username}','#{email}','#{bio}')")
    return true
  end

  def self.find_by_id(id)
    result = User.client.query("SELECT * FROM users WHERE id='#{id}'").first

    return nil if result.nil?
    User.new(
      result["id"], username: result["username"], email: result["email"], bio: result["bio"]
    )
  end
end
