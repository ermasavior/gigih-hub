require_relative '../../models/post_hashtag'

RSpec.describe 'PostHashtag' do
  let(:user) { User.new(1, username: "cici", email: "abc@gmail.com", bio: nil) }
  let(:text) { "Assalamualaikum #cantik" }
  let(:post) { Post.new(1, user: user, text: text) }
  let(:hashtags) { post.hashtags }

  describe 'initialize' do
    it 'creates a post hashtag' do
      post_hashtag = PostHashtag.new(post: post, hashtag: hashtags[0])

      expect(post_hashtag.post).to eq(post)
      expect(post_hashtag.hashtag).to eq(hashtags[0])
    end
  end
end
