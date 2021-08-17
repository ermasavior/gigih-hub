require_relative '../db/db_connector'

class User
  attr_accessor :id, :username, :email, :bio

  def initialize(id=nil, username:, email:, bio:)
    @id = id,
    @username = username,
    @email = email,
    @bio = bio
  end
end
