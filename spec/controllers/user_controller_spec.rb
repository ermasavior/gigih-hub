require_relative '../../controllers/user_controller'

RSpec.describe 'UserController' do
  let(:username) { 'erma' }
  let(:email) { 'erma@test.com' }
  let(:bio) { 'Simple.' }
  let(:params) { { 'username' => username, 'email' => email, 'bio' => bio } }

  describe '.create' do
    let(:user) { double }
    let(:user_hash) { double }
    let(:data) { user_hash }
    let(:expected_response) { { status: status, data: data } }

    it 'calls user.save with params' do
      expect(User).to receive(:new).with(username: username, email: email, bio: bio)
                                   .and_return(user)
      expect(user).to receive(:save).and_return(true)
      expect(user).to receive(:to_hash).and_return(user_hash)

      controller = UserController.new
      controller.create(params)
    end

    context 'check params' do
      before do
        allow(User).to receive(:new).with(username: username, email: email, bio: bio)
                                    .and_return(user)
        allow(user).to receive(:to_hash).and_return(user_hash)
      end

      context 'when params are valid' do
        let(:status) { 200 }

        it 'returns status 200' do
          allow(user).to receive(:save).and_return(true)

          controller = UserController.new
          response = controller.create(params)

          expect(response).to eq(expected_response)
        end
      end

      context 'when params are invalid' do
        let(:status) { 400 }
        let(:data) { nil }

        it 'returns status 400' do
          allow(user).to receive(:save).and_return(false)

          controller = UserController.new
          response = controller.create(params)

          expect(response).to eq(expected_response)
        end
      end
    end
  end
end
