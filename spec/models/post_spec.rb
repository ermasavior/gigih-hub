require_relative '../../models/post'

RSpec.describe 'Post' do
  let(:user) { User.new(1, username: 'erma', email: 'erma@test.com', bio: 'Simple.') }
  let(:text) { 'Hello, world! #hello' }
  let(:post_params) do
    {
      id: post_id, created_at: created_at, text: text, user: user,
      attachment: attachment, parent_post_id: parent_post_id
    }
  end

  let(:query_with_attachment) do
    "INSERT INTO posts(text, user_id, created_at, parent_post_id, attachment)
     VALUES ('#{text}','#{user.id}','#{created_at}',NULL,'#{attachment}')"
  end
  let(:query_without_attachment) do
    "INSERT INTO posts(text, user_id, created_at, parent_post_id, attachment)
     VALUES ('#{text}','#{user.id}','#{created_at}',NULL,NULL)"
  end

  describe 'initialize' do
    let(:post_id) { nil }
    let(:created_at) { nil }
    let(:attachment) { 'localhost/path/to/media' }
    let(:parent_post_id) { 1 }

    it 'creates new user' do
      post = Post.new(post_params)

      expect(post.id).to eq(post_id)
      expect(post.created_at).to eq(created_at)
      expect(post.text).to eq(text)
      expect(post.attachment).to eq(attachment)
      expect(post.user).to eq(user)
      expect(post.parent_post_id).to eq(parent_post_id)
    end

    context 'process hashtag' do
      let(:hashtag_texts) { ['hello'] }
      let(:hashtags) do
        hashtag_texts.map { |tag| Hashtag.new(text: tag) }
      end

      it 'triggers Hashtag.extract_hashtags' do
        expect(Hashtag).to receive(:extract_hashtags).with(text).once
                                                     .and_return(hashtags)

        post = Post.new(post_params)
        expect(post.hashtags).to eq(hashtags)
      end
    end
  end

  describe '.valid?' do
    let(:post_id) { nil }
    let(:created_at) { nil }
    let(:attachment) { 'localhost/path/to/media' }
    let(:parent_post_id) { 1 }

    context 'when attributes are valid' do
      it 'returns true' do
        post = Post.new(post_params)
        expect(post.valid?).to eq(true)
      end
    end

    context 'when attributes are invalid' do
      let(:text) { nil }

      it 'returns false' do
        post = Post.new(post_params)
        expect(post.valid?).to eq(false)
      end
    end
  end

  describe '.to_hash' do
    let(:post_id) { nil }
    let(:created_at) { nil }
    let(:attachment) { 'localhost/path/to/media' }
    let(:parent_post_id) { nil }

    let(:post) { Post.new(post_params) }
    let(:expected_hash) do
      {
        id: post.id, created_at: post.created_at, text: post.text, user: post.user.to_hash,
        parent_post_id: post.parent_post_id, hashtags: post.hashtags.map(&:to_hash),
        attachment: post.attachment
      }
    end

    it 'returns hash of attributes' do
      expect(post.to_hash).to eq(expected_hash)
    end
  end

  describe '.save' do
    let(:post_id) { nil }
    let(:created_at) { nil }
    let(:attachment) { nil }
    let(:parent_post_id) { nil }
    let(:parent_post_id_query) { 'NULL' }

    context 'when params are valid' do
      let(:creation_time) { nil }
      let(:time_now) { double }
      let(:hashtag_texts) { ['hello'] }
      let(:hashtags) do
        hashtag_texts.map { |tag| Hashtag.new(text: tag) }
      end
      let(:post_id) { 1 }
      let(:expected_query) { query_without_attachment }

      before(:each) do
        allow(Hashtag).to receive(:extract_hashtags).with(text).and_return(hashtags)
        allow(Post.client).to receive(:last_id).and_return(post_id)

        allow(Time).to receive(:now).and_return(time_now)
        allow(time_now).to receive(:strftime).with('%Y-%m-%d %H:%M:%S')
                                             .and_return(creation_time)
      end

      it 'returns true' do
        allow(Post.client).to receive(:query).with(expected_query)

        post = Post.new(post_params)
        expect(post.save).to eq(true)
      end

      it 'initialize id and created_at' do
        allow(Post.client).to receive(:query).with(expected_query)

        post = Post.new(post_params)
        post.save

        expect(post.id).to eq(post_id)
        expect(post.created_at).to eq(created_at)
      end

      context 'post triggers query' do
        context 'when there is attachment' do
          let(:attachment) { 'localhost/path/to/media' }
          let(:expected_query) { query_with_attachment }

          it 'triggers insert new post query with attachment' do
            expect(Post.client).to receive(:query).with(expected_query).once

            post = Post.new(post_params)
            post.save
          end
        end

        context 'when there is no attachment' do
          let(:expected_query) { query_without_attachment }

          it 'triggers insert new post query with attachment' do
            expect(Post.client).to receive(:query).with(expected_query).once

            post = Post.new(post_params)
            post.save
          end
        end
      end
    end

    context 'when params are invalid' do
      # rubocop:disable Layout/LineLength
      let(:too_long_text) do
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Na'
      end
      # rubocop:enable Layout/LineLength

      let(:text) { [nil, too_long_text].sample }

      it 'does not trigger query' do
        expect(Post.client).not_to receive(:query)

        post = Post.new(post_params)
        post.save
      end

      it 'returns false' do
        post = Post.new(post_params)
        expect(post.save).to eq(false)
      end
    end
  end

  describe '.save_hashtags' do
    let(:post_id) { 1 }
    let(:created_at) { '2021-08-20 23:23:12' }
    let(:attachment) { 'localhost/path/to/media' }
    let(:parent_post_id) { nil }
    let(:post_hashtag) { double }

    it 'triggers Hashtag and PostHashtag save' do
      post = Post.new(post_params)

      post.hashtags.each do |hashtag|
        expect(hashtag).to receive(:save).once
        expect(PostHashtag).to receive(:new).with(post: post, hashtag: hashtag).once
                                            .and_return(post_hashtag)
        expect(post_hashtag).to receive(:save).once
      end

      post.save_hashtags
    end
  end

  describe '.find_by_hashtag' do
    let(:post_id) { 2 }
    let(:parent_post_id) { 1 }
    let(:creation_time) { '2021-08-20 23:23:12' }
    let(:expected_query) do
      "SELECT posts.id, posts.text, posts.attachment, posts.user_id, posts.parent_post_id, posts.created_at
       FROM posts INNER JOIN post_hashtags ON posts.id = post_hashtags.post_id
       INNER JOIN hashtags ON hashtags.id = post_hashtags.hashtag_id
       WHERE hashtags.text = '#{hashtag.text}'"
    end
    let(:expected_query_result) do
      [{
        'id' => post_id, 'text' => text, 'user_id' => user.id,
        'parent_post_id' => parent_post_id, 'created_at' => creation_time
      }]
    end

    context 'when params is valid' do
      let(:hashtag) { Hashtag.new(text: '#hello') }

      before do
        allow(User).to receive(:find_by_id).with(user.id).and_return(user)
      end

      it 'triggers query to get posts by hashtag' do
        expect(Post.client).to receive(:query).with(expected_query)
                                              .and_return(expected_query_result)

        posts = Post.find_by_hashtag(hashtag)

        posts.each do |post|
          expect(post.id).to eq(post_id)
          expect(post.user).to eq(user)
          expect(post.text).to eq(text)
          expect(post.created_at).to eq(creation_time)
          expect(post.parent_post_id).to eq(parent_post_id)
        end
      end
    end

    context 'when params is invalid' do
      let(:hashtag) { nil }

      it 'returns empty array' do
        posts = Post.find_by_hashtag(hashtag)
        expect(posts).to eq([])
      end
    end
  end

  describe '.find_by_id' do
    context 'when post is found' do
      let(:post_id) { nil }
      let(:created_at) { nil }
      let(:text) { 'abc' }
      let(:user) { user }
      let(:attachment) { nil }
      let(:parent_post_id) { nil }

      let(:created_post_id) { Post.client.last_id }

      before do
        Post.new(post_params).save
      end

      it 'returns post' do
        post = Post.find_by_id(created_post_id)

        expect(post.text).to eq(text)
        expect(post.user.id).to eq(user.id)
        expect(created_at).not_to eq(nil)
      end

      after do
        Post.client.query("DELETE FROM posts WHERE id='#{created_post_id}'")
      end
    end
  end
end
