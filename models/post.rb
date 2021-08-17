require_relative '../models/model'

class Post < Model
  attr_accessor :id, :text, :created_at, :user, :hashtags

  def initialize(id=nil, created_at=nil, text:, user:)
    @id = id
    @created_at = created_at
    @text = text
    @user = user
    @hashtags = Hashtag.extract_hashtags(@text)
  end

  def save
    return false if @text.nil? or @text.size > 1000 or @user.nil?

    Post.client.query("INSERT INTO posts(text, user_id) VALUES ('#{text}','#{@user.id}')")

    @hashtags.each do |hashtag|
      hashtag.save
    end

    true
  end
end
