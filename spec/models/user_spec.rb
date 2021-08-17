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
    let(:expected_query) { "INSERT INTO users(username, bio, email) VALUES ('#{username}','#{bio}','#{@email}')" }

    it 'triggers query to insert new user' do
      expect(User.client).to receive(:query).with(expected_query).once

      user = User.new(
        username: username, email: email, bio: bio
      )
      user.save
    end
  end
end
