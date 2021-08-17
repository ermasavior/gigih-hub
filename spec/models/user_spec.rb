require_relative '../../models/user'

RSpec.describe 'User' do
  describe '.new' do
    let(:username) { "erma" }
    let(:email) { "erma@test.com" }
    let(:bio) { "Simple." }

    it 'creates new user' do
      user = User.new(
        username: username, email: email, bio: bio
      )

      expect(user.username).to eq(username)
      expect(user.email).to eq(email)
      expect(user.bio).to eq(bio)
    end
  end
end
