require_relative '../models/model'
require_relative '../models/hashtag'
require 'date'

class Post < Model
  attr_reader :id, :text, :created_at, :user, :attachment, :hashtags, :parent_post_id

  def initialize(id = nil, parent_post_id = nil, created_at = nil, attachment = nil, text:, user:)
    @id = id
    @created_at = created_at
    @text = text
    @user = user
    @hashtags = Hashtag.extract_hashtags(@text)
    @parent_post_id = parent_post_id
    @attachment = attachment
  end

  def to_hash
    {
      id: id, created_at: created_at, text: text, user: user.to_hash,
      parent_post_id: parent_post_id, hashtags: hashtags.map(&:to_hash),
      attachment: attachment
    }
  end

  def valid?
    return false if @user.nil?
    return false if @text.nil? || (@text.size > 1000)

    true
  end

  def save
    return false unless valid?

    current_time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    query = get_insert_query(current_time)
    Post.client.query(query)

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

  # rubocop:disable Metrics/MethodLength
  def self.find_by_hashtag(hashtag)
    return [] if hashtag.nil?

    results = Post.client.query(
      "SELECT posts.id, posts.text, posts.attachment, posts.user_id, posts.parent_post_id, posts.created_at
       FROM posts INNER JOIN post_hashtags ON posts.id = post_hashtags.post_id
       INNER JOIN hashtags ON hashtags.id = post_hashtags.hashtag_id
       WHERE hashtags.text = '#{hashtag.text}'"
    )

    posts = []
    results.each do |result|
      user = User.find_by_id(result['user_id'])
      posts << Post.new(
        result['id'], result['parent_post_id'], result['created_at'], user: user, text: result['text']
      )
    end

    posts
  end
  # rubocop:enable Metrics/MethodLength

  private

  def get_insert_query(current_time)
    attachment = "'#{@attachment}'"
    attachment = 'NULL' if attachment_valid?

    parent_post_id = "'#{@parent_post_id}'"
    parent_post_id = 'NULL' if parent_post_id_valid?

    "INSERT INTO posts(text, user_id, created_at, parent_post_id, attachment)
     VALUES ('#{@text}','#{@user.id}','#{current_time}',#{parent_post_id},#{attachment})"
  end

  def attachment_valid?
    @attachment.nil? || @attachment == ''
  end

  def parent_post_id_valid?
    @parent_post_id.nil? || @parent_post_id == ''
  end
end
