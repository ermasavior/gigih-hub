require_relative '../models/model'

class PostHashtag < Model
  attr_reader :post, :hashtag

  def initialize(post:, hashtag:)
    @post = post
    @hashtag = hashtag
  end

  def to_hash
    {
      post: post.to_hash, hashtag: hashtag.to_hash
    }
  end

  def save
    return false if @post.nil? || @hashtag.nil?
    return false if @post.id.nil? || @hashtag.id.nil?

    PostHashtag.client.query("INSERT INTO post_hashtags(post_id, hashtag_id) VALUES ('#{@post.id}','#{@hashtag.id}')")
    true
  end
end
