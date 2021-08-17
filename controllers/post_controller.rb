require_relative '../models/post'

class PostController
  def create(params)
    user = User.find_by_id(params['user_id'])
    post = Post.new(user: user, text: params['text'])
    post.save
  end
end
