require_relative '../../controllers/post_controller'

RSpec.describe 'PostController' do
  let(:user) { User.new(1, username: 'erma', email: 'erma@test.com', bio: 'Simple.') }
  let(:text) { 'Lorem ipsum dolor sit amet.' }
  let(:post) { double }
  let(:post_hash) { double }
  let(:expected_response) { { status: status, data: data } }

  let(:attachment_params) { { 'filename' => 'dummy.txt', 'base_url' => 'http://localhost/', 'tempfile' => double } }
  let(:attachment_uploader) { double }
  let(:attachment_filepath) { 'http://localhost/storage/dummy.txt' }

  describe '.create_post' do
    let(:params) { { 'user_id' => user.id, 'text' => text, 'attachment' => attachment_params } }
    let(:post_params) do
      {
        text: text, user: user, attachment: attachment_filepath
      }
    end

    it 'invokes AttachmentUploader, User and Post class' do
      expect(AttachmentUploader).to receive(:new).with(attachment_params)
                                                 .and_return(attachment_uploader)
      expect(attachment_uploader).to receive(:upload).and_return(attachment_filepath)
      expect(User).to receive(:find_by_id).with(user.id).and_return(user)
      expect(Post).to receive(:new).with(post_params)
                                   .and_return(post)

      expect(post).to receive(:save).and_return(true)
      expect(post).to receive(:save_hashtags)
      expect(post).to receive(:to_hash).and_return(post_hash)

      controller = PostController.new
      controller.create_post(params)
    end

    context 'check params' do
      before do
        allow(AttachmentUploader).to receive(:new).with(attachment_params)
                                                  .and_return(attachment_uploader)
        allow(attachment_uploader).to receive(:upload).and_return(attachment_filepath)
        allow(User).to receive(:find_by_id).with(user.id).and_return(user)
        allow(Post).to receive(:new).with(post_params)
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
    let(:parent_post) { double }
    let(:params) do
      {
        'user_id' => user.id, 'id' => parent_post_id,
        'text' => text, 'attachment' => attachment_params
      }
    end
    let(:post_params) do
      {
        text: text, user: user, attachment: attachment_filepath, parent_post_id: parent_post_id
      }
    end

    it 'invokes AttachmentUploader service, User and Post classes' do
      expect(AttachmentUploader).to receive(:new).with(attachment_params)
                                                 .and_return(attachment_uploader)
      expect(attachment_uploader).to receive(:upload).and_return(attachment_filepath)

      expect(Post).to receive(:find_by_id).with(parent_post_id).and_return(parent_post)
      expect(parent_post).to receive(:id).and_return(parent_post_id)
      expect(User).to receive(:find_by_id).with(user.id).and_return(user)
      expect(Post).to receive(:new).with(post_params)
                                   .and_return(post)

      expect(post).to receive(:save).and_return(true)
      expect(post).to receive(:save_hashtags)
      expect(post).to receive(:to_hash).and_return(post_hash)

      controller = PostController.new
      controller.create_comment(params)
    end

    context 'check params' do
      before do
        allow(AttachmentUploader).to receive(:new).with(attachment_params)
                                                  .and_return(attachment_uploader)
        allow(attachment_uploader).to receive(:upload).and_return(attachment_filepath)
        allow(User).to receive(:find_by_id).with(user.id).and_return(user)
        allow(Post).to receive(:new).with(post_params)
                                    .and_return(post)
        allow(post).to receive(:save_hashtags)
        allow(post).to receive(:to_hash).and_return(post_hash)
      end

      context 'when params are valid' do
        let(:status) { 200 }
        let(:data) { post.to_hash }

        it 'returns status 200' do
          allow(Post).to receive(:find_by_id).and_return(parent_post)
          allow(parent_post).to receive(:id).and_return(parent_post_id)
          allow(post).to receive(:save).and_return(true)

          controller = PostController.new
          response = controller.create_comment(params)

          expect(response).to eq(expected_response)
        end
      end

      context 'when params are invalid' do
        let(:parent_post_id) { [nil, ''].sample }
        let(:status) { 404 }
        let(:data) { nil }

        it 'returns status 404 not found' do
          controller = PostController.new
          response = controller.create_comment(params)

          expect(response).to eq(expected_response)
        end
      end
    end
  end

  describe '.fetch_by_hashtag' do
    context 'when params are valid' do
      let(:hashtag_text) { '#gigih' }
      let(:params) { { 'hashtag_text' => hashtag_text } }
      let(:hashtag) { Hashtag.new(text: hashtag_text) }
      let(:posts) do
        [
          Post.new(user: user, text: 'Mari #gigih'),
          Post.new(user: user, text: 'Semangat #gigih'),
          Post.new(user: user, text: 'Kelas #gigih')
        ]
      end
      let(:data) { posts.map(&:to_hash) }
      let(:expected_response) do
        { status: 200, data: data }
      end

      before do
        allow(Hashtag).to receive(:find_by_text).with(hashtag_text)
                                                .and_return(hashtag)
        allow(Post).to receive(:find_by_hashtag).with(hashtag)
                                                .and_return(posts)
      end

      it 'returns expected response with status code 200' do
        controller = PostController.new
        response = controller.fetch_by_hashtag(params)
        expect(response).to eq(expected_response)
      end
    end

    context 'when params are invalid' do
      let(:hashtag_text) { ['', nil].sample }
      let(:params) { { 'hashtag_text' => hashtag_text } }
      let(:expected_response) do
        { status: 400, data: nil }
      end

      it 'returns expected response with status code 400' do
        controller = PostController.new
        response = controller.fetch_by_hashtag(params)
        expect(response).to eq(expected_response)
      end
    end
  end
end
