require_relative '../../controllers/post_controller'

RSpec.describe 'PostController' do
  let(:user) { User.new(1, username:"erma", email: "erma@test.com", bio: "Simple.")}
  let(:text) { 'Lorem ipsum dolor sit amet.' }
  let(:params) { {'user_id' => user.id, 'text' => text} }
  
  describe '.create' do
    let(:post) { double }
    let(:hashtags) { [ double ] }
    let(:post_hashtag) { double }
    let(:expected_response) { { status: status } }

    it 'calls post.save with params' do
      expect(User).to receive(:find_by_id).with(user.id).and_return(user)
      expect(Post).to receive(:new).with(text: text, user: user)
        .and_return(post)
      expect(post).to receive(:save)

      controller = PostController.new
      controller.create(params)
    end

    context 'check params' do
      before do
        allow(User).to receive(:find_by_id).with(user.id).and_return(user)
        allow(Post).to receive(:new).with(text: text, user: user)
          .and_return(post)
        allow(post).to receive(:hashtags).and_return(hashtags)

        hashtags.each do |hashtag|
          allow(hashtag).to receive(:save)
          allow(PostHashtag).to receive(:new).with(post: post, hashtag: hashtag)
            .and_return(post_hashtag)
          allow(post_hashtag).to receive(:save)
        end
      end

      context 'when params are valid' do
        let(:status) { 200 }

        it 'returns status 200' do
          allow(post).to receive(:save).and_return(true)        

          controller = PostController.new
          response = controller.create(params)

          expect(response).to eq(expected_response)
        end
      end

      context 'when params are invalid' do
        let(:status) { 400 }

        it 'returns status 400' do
          allow(post).to receive(:save).and_return(false)        

          controller = PostController.new
          response = controller.create(params)

          expect(response).to eq(expected_response)
        end
      end
    end
  end
end
