require_relative '../../models/post'

RSpec.describe 'Post' do
  let(:user) { User.new(1, username:"erma", email: "erma@test.com", bio: "Simple.")}
  let(:text) { "Hello, world! #hello" }

  describe 'initialize' do
    it 'creates new user' do
      post = Post.new(text: text, user: user)

      expect(post.text).to eq(text)
      expect(post.user).to eq(user)
    end
  end

  describe '.save' do
    context 'when params are valid' do
      let(:expected_query) { "INSERT INTO posts(text, user_id) VALUES ('#{text}','#{user.id}')" }

      it 'triggers insert new post query' do
        expect(Post.client).to receive(:query).with(expected_query).once

        post = Post.new(text: text, user: user)
        post.save
      end

      it 'returns true' do
        allow(Post.client).to receive(:query).with(expected_query)

        post = Post.new(text: text, user: user)
        expect(post.save).to eq(true)
      end
    end

    context 'when params are invalid' do
      it 'does not trigger query' do
        expect(Post.client).not_to receive(:query)

        post = Post.new(text: text, user: user)
        post.save
      end

      it 'returns false' do
        post = Post.new(text: text, user: user)
        expect(post.save).to eq(false)
      end
    end
  end
end
