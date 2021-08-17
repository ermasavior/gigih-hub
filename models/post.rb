require_relative '../models/model'

class Post < Model
  attr_accessor :id, :text, :created_at, :user

  def initialize(id=nil, created_at=nil, text:, user:)
    @id = id
    @created_at = created_at
    @text = text
    @user = user
  end

  def save
    Post.client.query("INSERT INTO posts(text, user_id) VALUES ('#{text}','#{@user.id}')")
    return true
  end
end
