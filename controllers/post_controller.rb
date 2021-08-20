require_relative '../models/user'
require_relative '../models/post'
require_relative '../models/post_hashtag'

class PostController
  def create_post(params)
    user = User.find_by_id(params['user_id'])
    post = Post.new(user: user, text: params['text'])
    save_success = post.save

    return { status: 400 } unless save_success

    post.hashtags.each do |hashtag|
      hashtag.save
      PostHashtag.new(post: post, hashtag: hashtag).save
    end

    { status: 200 }
  end

  def create_comment(params)
    parent_post_id = params['parent_post_id']
    return { status: 400 } if parent_post_id.nil? || parent_post_id == ''

    user = User.find_by_id(params['user_id'])
    post = Post.new(
      nil, parent_post_id, user: user, text: params['text']
    )
    save_success = post.save

    return { status: 400 } unless save_success

    post.hashtags.each do |hashtag|
      hashtag.save
      PostHashtag.new(post: post, hashtag: hashtag).save
    end

    { status: 200 }
  end
end
