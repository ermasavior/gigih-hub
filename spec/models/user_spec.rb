require_relative '../../models/user'

RSpec.describe 'User' do
  let(:username) { 'erma' }
  let(:email) { 'erma@test.com' }
  let(:bio) { 'Simple.' }

  describe 'initialize' do
    it 'creates new user' do
      user = User.new(
        username: username, email: email, bio: bio
      )

      expect(user.username).to eq(username)
      expect(user.email).to eq(email)
      expect(user.bio).to eq(bio)
    end
  end

  describe '.to_hash' do
    let(:user) { User.new(username: username, email: email, bio: bio) }
    let(:expected_hash) { { id: user.id, username: user.username, email: user.email, bio: user.bio } }

    it 'returns hash of attributes' do
      expect(user.to_hash).to eq(expected_hash)
    end
  end

  describe '.save' do
    context 'when params are valid' do
      let(:expected_query) { "INSERT INTO users(username, email, bio) VALUES ('#{username}','#{email}','#{bio}')" }
      let(:user_last_id) { 1 }

      before do
        allow(User.client).to receive(:last_id).and_return(user_last_id)
      end

      it 'triggers query to insert new user' do
        expect(User.client).to receive(:query).with(expected_query).once

        user = User.new(
          username: username, email: email, bio: bio
        )
        user.save
      end

      it 'returns true' do
        allow(User.client).to receive(:query).with(expected_query)

        user = User.new(
          username: username, email: email, bio: bio
        )
        expect(user.save).to eq(true)
      end

      it 'initialize user id' do
        allow(User.client).to receive(:query).with(expected_query)

        user = User.new(
          username: username, email: email, bio: bio
        )
        user.save
        expect(user.id).to eq(user_last_id)
      end
    end

    context 'when params are invalid' do
      let(:username) { nil }
      let(:email) { nil }
      let(:bio) { nil }

      it 'does not trigger query' do
        expect(User.client).not_to receive(:query)

        user = User.new(
          username: username, email: email, bio: bio
        )
        user.save
      end

      it 'returns false' do
        user = User.new(
          username: username, email: email, bio: bio
        )
        expect(user.save).to eq(false)
      end
    end
  end

  describe '.find_by_id' do
    context 'when user is found' do
      let(:user_id) { User.client.last_id }

      before do
        User.new(username: username, email: email, bio: bio).save
      end

      it 'returns user' do
        user = User.find_by_id(user_id)

        expect(user.id).to eq(user_id)
        expect(user.username).to eq(username)
        expect(user.email).to eq(email)
        expect(user.bio).to eq(bio)
      end

      after do
        User.client.query("DELETE FROM users WHERE id='#{user_id}'")
      end
    end

    context 'when user is not found' do
      let(:user_id) { -1 }

      it 'returns nil' do
        user = User.find_by_id(user_id)
        expect(user).to eq(nil)
      end
    end
  end
end
