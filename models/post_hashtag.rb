require_relative '../models/model'

class PostHashtag < Model
  attr_reader :post, :hashtag

  def initialize(post:, hashtag:)
    @post = post
    @hashtag = hashtag
  end

  def save
    return false if @post.nil? or @hashtag.nil?

    PostHashtag.client.query("INSERT INTO post_hashtags(post_id, hashtag_id) VALUES ('#{@post.id}','#{@hashtag.id}')")
    true
  end
end