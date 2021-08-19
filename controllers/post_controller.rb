require_relative '../models/post'

class PostController
  def create(params)
    user = User.find_by_id(params['user_id'])
    post = Post.new(user: user, text: params['text'])
    save_success = post.save

    post.hashtags.each do |hashtag|
      hashtag.save
      PostHashtag.new(post: post, hashtag: hashtag).save
    end

    return { status: 200 } if save_success
    { status: 400 }
  end
end
