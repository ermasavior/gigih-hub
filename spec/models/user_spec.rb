require_relative '../../models/user'

RSpec.describe 'User' do
  let(:username) { "erma" }
  let(:email) { "erma@test.com" }
  let(:bio) { "Simple." }

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

  describe '.save' do
    context 'when params are valid' do
      let(:expected_query) { "INSERT INTO users(username, email, bio) VALUES ('#{username}','#{email}','#{bio}')" }

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
end
