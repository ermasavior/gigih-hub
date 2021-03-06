require_relative '../models/user'
require_relative '../models/post'
require_relative '../models/post_hashtag'
require_relative '../services/attachment_uploader'

class PostController
  def create_post(params)
    user = User.find_by_id(params['user_id'])

    params = { text: params['text'], user: user,
               attachment: upload_attachment_filepath(params['attachment']) }
    post = Post.new(params)

    save_success = post.save
    return { status: 400, data: nil } unless save_success

    post.save_hashtags

    { status: 200, data: post.to_hash }
  end

  def create_comment(params)
    parent_post = Post.find_by_id(params['id'])
    return { status: 404, data: nil } if parent_post.nil?

    user = User.find_by_id(params['user_id'])

    params = { text: params['text'], user: user, parent_post_id: parent_post.id,
               attachment: upload_attachment_filepath(params['attachment']) }
    post = Post.new(params)

    save_success = post.save
    return { status: 400, data: nil } unless save_success

    post.save_hashtags

    { status: 200, data: post.to_hash }
  end

  def fetch_by_hashtag(params)
    hashtag_text = params['hashtag_text']
    return { status: 400, data: nil } if hashtag_text.nil? || hashtag_text == ''

    hashtag = Hashtag.find_by_text(hashtag_text.downcase)
    posts = Post.find_by_hashtag(hashtag)

    {
      status: 200,
      data: posts.map(&:to_hash)
    }
  end

  private

  def upload_attachment_filepath(attachment_param)
    attachment_uploader = AttachmentUploader.new(attachment_param)
    attachment_uploader.upload
  end
end
