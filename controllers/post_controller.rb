require_relative '../models/user'
require_relative '../models/post'
require_relative '../models/post_hashtag'
require_relative '../services/attachment_uploader'

class PostController
  def create_post(params)
    user = User.find_by_id(params['user_id'])

    attachment_uploader = AttachmentUploader.new(params['attachment'])
    attachment_filepath = attachment_uploader.upload

    params = {
      text: params['text'], user: user, attachment: attachment_filepath
    }
    post = Post.new(params)

    save_success = post.save
    return { status: 400, data: nil } unless save_success

    post.save_hashtags

    { status: 200, data: post.to_hash }
  end

  def create_comment(params)
    parent_post_id = params['id']
    return { status: 400, data: nil } if parent_post_id.nil? || parent_post_id == ''

    user = User.find_by_id(params['user_id'])

    attachment_uploader = AttachmentUploader.new(params['attachment'])
    attachment_filepath = attachment_uploader.upload

    params = {
      text: params['text'], user: user, attachment: attachment_filepath,
      parent_post_id: parent_post_id
    }
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
end
