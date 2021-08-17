require_relative '../../controllers/user_controller'

RSpec.describe 'UserController' do
  let(:username) { 'erma' }
  let(:email) { 'erma@test.com' }
  let(:bio) { 'Simple.' }
  let(:params) { {'username' => username, 'email' => email, 'bio' => bio} }

  describe '.create' do
    let(:user_stub) { double }

    it 'calls user.save with params' do
      expect(User).to receive(:new).with(username: username, email: email, bio: bio)
        .and_return(user_stub)
      expect(user_stub).to receive(:save)

      controller = UserController.new
      controller.create(params)
    end
  end
end
