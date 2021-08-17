require_relative '../../controllers/post_controller'

RSpec.describe 'PostController' do
  let(:user) { User.new(1, username:"erma", email: "erma@test.com", bio: "Simple.")}
  let(:text) { 'Lorem ipsum dolor sit amet.' }
  let(:params) { {'user_id' => user.id, 'text' => text} }
  
  describe '.create' do
    let(:post_stub) { double }
    let(:expected_response) { { status: status } }

    it 'calls post.save with params' do
      expect(Post).to receive(:new).with(text: text, user: user)
        .and_return(post_stub)
      expect(post_stub).to receive(:save)

      controller = PostController.new
      controller.create(params)
    end
  end
end
