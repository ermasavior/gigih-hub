require_relative '../models/model'
require_relative '../models/hashtag'

class Post < Model
  attr_accessor :id, :text, :created_at, :user, :hashtags

  def initialize(id = nil, created_at = nil, text:, user:)
    @id = id
    @created_at = created_at
    @text = text
    @user = user
    @hashtags = Hashtag.extract_hashtags(@text)
  end

  def save
    return false if @text.nil? || (@text.size > 1000) || @user.nil?

    Post.client.query("INSERT INTO posts(text, user_id) VALUES ('#{text}','#{@user.id}')")
    @id = Post.client.last_id
    true
  end
end
