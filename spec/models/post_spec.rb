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

    context 'process hashtag' do
      let(:hashtag_texts) { ["hello"] }
      let(:hashtags) {
        hashtag_texts.map { |tag| Hashtag.new(text: tag) }
      }

      it 'triggers Hashtag.extract_hashtags' do
        expect(Hashtag).to receive(:extract_hashtags).with(text).once
          .and_return(hashtags)

        post = Post.new(text: text, user: user)
        expect(post.hashtags).to eq(hashtags)
      end
    end
  end

  describe '.save' do
    context 'when params are valid' do
      let(:expected_query) { "INSERT INTO posts(text, user_id) VALUES ('#{text}','#{user.id}')" }
      let(:hashtag_texts) { ["hello"] }
      let(:hashtags) {
        hashtag_texts.map { |tag| Hashtag.new(text: tag) }
      }

      before(:each) do
        allow(Hashtag).to receive(:extract_hashtags).with(text).and_return(hashtags)
      end

      it 'triggers insert new post query' do
        hashtags.each do |tag|
          allow(tag).to receive(:save).and_return(true)
        end
        expect(Post.client).to receive(:query).with(expected_query).once

        post = Post.new(text: text, user: user)
        post.save
      end

      it 'returns true' do
        hashtags.each do |tag|
          allow(tag).to receive(:save).and_return(true)
        end
        allow(Post.client).to receive(:query).with(expected_query)

        post = Post.new(text: text, user: user)
        expect(post.save).to eq(true)
      end

      it 'triggers hashtag.save' do
        hashtags.each do |tag|
          expect(tag).to receive(:save).and_return(true)
        end
        allow(Post.client).to receive(:query).with(expected_query)

        post = Post.new(text: text, user: user)
        post.save

        expect(post.hashtags).to eq(hashtags)
      end
    end

    context 'when params are invalid' do
      let(:too_long_text) { "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Na" }
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
end
