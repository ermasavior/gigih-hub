require_relative '../models/model'
require_relative '../models/hashtag'
require 'date'

class Post < Model
  attr_reader :id, :text, :created_at, :user, :hashtags

  def initialize(id = nil, created_at = nil, text:, user:)
    @id = id
    @created_at = created_at
    @text = text
    @user = user
    @hashtags = Hashtag.extract_hashtags(@text)
  end

  def save
    return false if @text.nil? || (@text.size > 1000) || @user.nil?

    current_time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    Post.client.query("INSERT INTO posts(text, user_id, created_at) VALUES ('#{text}','#{user.id}','#{current_time}')")

    @id = Post.client.last_id
    @created_at = current_time
    true
  end
end
