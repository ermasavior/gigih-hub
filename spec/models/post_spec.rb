require_relative '../../models/post'

RSpec.describe 'Post' do
  let(:user) { User.new(1, username: 'erma', email: 'erma@test.com', bio: 'Simple.') }
  let(:text) { 'Hello, world! #hello' }
  let(:parent_post_id) { 1 }

  describe 'initialize' do
    it 'creates new user' do
      post = Post.new(nil, parent_post_id, text: text, user: user)

      expect(post.text).to eq(text)
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

        post = Post.new(text: text, user: user)
        expect(post.hashtags).to eq(hashtags)
      end
    end
  end

  describe '.valid?' do
    context 'when attributes are valid' do
      it 'returns true' do
        post = Post.new(text: text, user: user)
        expect(post.valid?).to eq(true)
      end
    end

    context 'when attributes are invalid' do
      let(:text) { nil }

      it 'returns false' do
        post = Post.new(text: text, user: user)
        expect(post.valid?).to eq(false)
      end
    end
  end

  describe '.to_hash' do
    let(:post) { Post.new(user: user, text: text) }
    let(:expected_hash) do
      {
        id: post.id, created_at: post.created_at, text: post.text, user: post.user.to_hash,
        parent_post_id: post.parent_post_id, hashtags: post.hashtags.map(&:to_hash)
      }
    end

    it 'returns hash of attributes' do
      expect(post.to_hash).to eq(expected_hash)
    end
  end

  describe '.save' do
    context 'when params are valid' do
      let(:parent_post_id_query) { 'NULL' }
      let(:created_at) { '2021-08-20 23:23:12' }
      let(:time_now) { double }
      let(:expected_query) do
        "
      INSERT INTO posts(text, user_id, parent_post_id, created_at)
      VALUES ('#{text}',#{user.id},#{parent_post_id_query},'#{created_at}')
    "
      end
      let(:hashtag_texts) { ['hello'] }
      let(:hashtags) do
        hashtag_texts.map { |tag| Hashtag.new(text: tag) }
      end
      let(:post_id) { 1 }

      before(:each) do
        allow(Hashtag).to receive(:extract_hashtags).with(text).and_return(hashtags)
        allow(Post.client).to receive(:last_id).and_return(post_id)

        allow(Time).to receive(:now).and_return(time_now)
        allow(time_now).to receive(:strftime).with('%Y-%m-%d %H:%M:%S')
                                             .and_return(created_at)
      end

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

      it 'initialize id and created_at' do
        allow(Post.client).to receive(:query).with(expected_query)

        post = Post.new(text: text, user: user)
        post.save

        expect(post.id).to eq(post_id)
        expect(post.created_at).to eq(created_at)
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

        post = Post.new(text: text, user: user)
        post.save
      end

      it 'returns false' do
        post = Post.new(text: text, user: user)
        expect(post.save).to eq(false)
      end
    end
  end

  describe '.save_hashtags' do
    let(:post_hashtag) { double }

    it 'triggers Hashtag and PostHashtag save' do
      post = Post.new(text: text, user: user)

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
    let(:post_id) { 1 }
    let(:created_at) { '2021-08-20 23:23:12' }
    let(:hashtag) { Hashtag.new(text: "#hello") }
    let(:expected_query) do
      "SELECT posts.id, posts.text, posts.attachment, posts.user_id, posts.parent_post_id, posts.created_at
       FROM posts INNER JOIN post_hashtags ON posts.id = post_hashtags.post_id
       INNER JOIN hashtags ON hashtags.id = post_hashtags.hashtag_id
       WHERE hashtags.text = '#{hashtag.text}'"
    end
    let(:expected_query_result) do
      [ { 'id' => post_id, 'text' => text, 'user_id' => user.id, 'parent_post_id' => parent_post_id, 'created_at' => created_at } ]
    end

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
        expect(post.created_at).to eq(created_at)
        expect(post.parent_post_id).to eq(parent_post_id)
      end
    end
  end
end
