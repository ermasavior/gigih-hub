require_relative '../models/model'

class PostHashtag < Model
  attr_reader :post, :hashtag

  def initialize(post:, hashtag:)
    @post = post
    @hashtag = hashtag
  end
end
