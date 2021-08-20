require_relative '../models/model'
require_relative '../models/hashtag'
require 'date'

class Post < Model
  attr_reader :id, :text, :created_at, :user, :hashtags, :parent_post_id

  def initialize(id = nil, parent_post_id = nil, text:, user:)
    @id = id
    @created_at = created_at
    @text = text
    @user = user
    @hashtags = Hashtag.extract_hashtags(@text)
    @parent_post_id = parent_post_id
  end

  def to_hash
    {
      id: id, created_at: created_at, text: text, user: user.to_hash,
      parent_post_id: parent_post_id, hashtags: hashtags.map(&:to_hash)
    }
  end

  def valid?
    return false if @user.nil?
    return false if @text.nil? || (@text.size > 1000)

    true
  end

  def save
    return false unless valid?

    parent_post_id = 'NULL' if parent_post_id.nil? || parent_post_id == ''
    current_time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    Post.client.query("
      INSERT INTO posts(text, user_id, parent_post_id, created_at)
      VALUES ('#{text}',#{user.id},#{parent_post_id},'#{current_time}')
    ")

    @id = Post.client.last_id
    @created_at = current_time
    true
  end

  def save_hashtags
    @hashtags.each do |hashtag|
      hashtag.save
      PostHashtag.new(post: self, hashtag: hashtag).save
    end
  end
end
