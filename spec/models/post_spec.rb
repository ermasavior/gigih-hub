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
end
