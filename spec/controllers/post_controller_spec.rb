require_relative '../../controllers/post_controller'

RSpec.describe 'PostController' do
  let(:user) { User.new(1, username: 'erma', email: 'erma@test.com', bio: 'Simple.') }
  let(:text) { 'Lorem ipsum dolor sit amet.' }
  let(:post) { double }
  let(:post_hash) { double }
  let(:expected_response) { { status: status, data: data } }

  describe '.create_post' do
    let(:params) { { 'user_id' => user.id, 'text' => text } }

    it 'invokes User and Post class' do
      expect(User).to receive(:find_by_id).with(user.id).and_return(user)
      expect(Post).to receive(:new).with(text: text, user: user)
                                   .and_return(post)

      expect(post).to receive(:save).and_return(true)
      expect(post).to receive(:save_hashtags)
      expect(post).to receive(:to_hash).and_return(post_hash)

      controller = PostController.new
      controller.create_post(params)
    end

    context 'check params' do
      before do
        allow(User).to receive(:find_by_id).with(user.id).and_return(user)
        allow(Post).to receive(:new).with(text: text, user: user)
                                    .and_return(post)
        allow(post).to receive(:save_hashtags)
        allow(post).to receive(:to_hash).and_return(post_hash)
      end

      context 'when params are valid' do
        let(:status) { 200 }
        let(:data) { post.to_hash }

        it 'returns status 200' do
          allow(post).to receive(:save).and_return(true)

          controller = PostController.new
          response = controller.create_post(params)

          expect(response).to eq(expected_response)
        end
      end

      context 'when params are invalid' do
        let(:status) { 400 }
        let(:data) { nil }

        it 'returns status 400' do
          allow(post).to receive(:save).and_return(false)

          controller = PostController.new
          response = controller.create_post(params)

          expect(response).to eq(expected_response)
        end
      end
    end
  end

  describe '.create_comment' do
    let(:parent_post_id) { 1 }
    let(:params) { { 'user_id' => user.id, 'id' => parent_post_id, 'text' => text } }

    it 'invokes user and post classes' do
      expect(User).to receive(:find_by_id).with(user.id).and_return(user)
      expect(Post).to receive(:new).with(nil, parent_post_id, text: text, user: user)
                                   .and_return(post)

      expect(post).to receive(:save).and_return(true)
      expect(post).to receive(:save_hashtags)
      expect(post).to receive(:to_hash).and_return(post_hash)

      controller = PostController.new
      controller.create_comment(params)
    end

    context 'check params' do
      before do
        allow(User).to receive(:find_by_id).with(user.id).and_return(user)
        allow(Post).to receive(:new).with(nil, parent_post_id, text: text, user: user)
                                    .and_return(post)
        allow(post).to receive(:save_hashtags)
        allow(post).to receive(:to_hash).and_return(post_hash)
      end

      context 'when params are valid' do
        let(:status) { 200 }
        let(:data) { post.to_hash }

        it 'returns status 200' do
          allow(post).to receive(:save).and_return(true)

          controller = PostController.new
          response = controller.create_comment(params)

          expect(response).to eq(expected_response)
        end
      end

      context 'when params are invalid' do
        let(:parent_post_id) { [nil, ''].sample }
        let(:status) { 400 }
        let(:data) { nil }

        it 'returns status 400' do
          controller = PostController.new
          response = controller.create_comment(params)

          expect(response).to eq(expected_response)
        end
      end
    end
  end
end
