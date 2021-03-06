require_relative '../../models/post_hashtag'

RSpec.describe 'PostHashtag' do
  let(:user) { User.new(1, username: 'cici', email: 'abc@gmail.com', bio: nil) }
  let(:text) { 'Assalamualaikum #cantik' }
  let(:post_id) { 1 }
  let(:post_params) do
    {
      id: post_id, created_at: '2021-08-20 23:23:12', text: text, user: user,
      attachment: nil, parent_post_id: nil
    }
  end
  let(:post) { Post.new(post_params) }
  let(:hashtag) { Hashtag.new(1, text: '#cantik') }

  before(:each) do
    allow(Hashtag).to receive(:extract_hashtags).with(text).and_return([hashtag])
  end

  describe 'initialize' do
    it 'creates a post hashtag' do
      post_hashtag = PostHashtag.new(post: post, hashtag: hashtag)

      expect(post_hashtag.post).to eq(post)
      expect(post_hashtag.hashtag).to eq(hashtag)
    end
  end

  describe '.to_hash' do
    let(:post_hashtag) { PostHashtag.new(post: post, hashtag: hashtag) }
    let(:expected_hash) { { post: post.to_hash, hashtag: hashtag.to_hash } }

    it 'returns hash of attributes' do
      expect(post_hashtag.to_hash).to eq(expected_hash)
    end
  end

  describe '.save' do
    context 'when params are valid' do
      let(:expected_query) { "INSERT INTO post_hashtags(post_id, hashtag_id) VALUES ('#{post.id}','#{hashtag.id}')" }

      it 'triggers insert new posthastag' do
        expect(PostHashtag.client).to receive(:query).with(expected_query).once

        post_hashtag = PostHashtag.new(post: post, hashtag: hashtag)
        post_hashtag.save
      end

      it 'returns true' do
        allow(PostHashtag.client).to receive(:query).with(expected_query)

        post_hashtag = PostHashtag.new(post: post, hashtag: hashtag)
        expect(post_hashtag.save).to eq(true)
      end
    end

    context 'when params are invalid' do
      let(:post_id) { nil }
      let(:post) { [Post.new(post_params), nil].sample }
      let(:hashtag) { [Hashtag.new(nil, text: '#cantik'), nil].sample }

      it 'does not trigger insert new posthashtag' do
        expect(PostHashtag.client).not_to receive(:query)

        post_hashtag = PostHashtag.new(post: post, hashtag: hashtag)
        post_hashtag.save
      end

      it 'returns false' do
        post_hashtag = PostHashtag.new(post: post, hashtag: hashtag)
        expect(post_hashtag.save).to eq(false)
      end
    end
  end
end
