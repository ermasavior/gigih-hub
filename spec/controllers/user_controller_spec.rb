require_relative '../../controllers/user_controller'

RSpec.describe 'UserController' do
  let(:username) { 'erma' }
  let(:email) { 'erma@test.com' }
  let(:bio) { 'Simple.' }
  let(:params) { {'username' => username, 'email' => email, 'bio' => bio} }

  describe '.create' do
    let(:user_stub) { double }
    let(:expected_response) { { status: status } }

    it 'calls user.save with params' do
      expect(User).to receive(:new).with(username: username, email: email, bio: bio)
        .and_return(user_stub)
      expect(user_stub).to receive(:save)

      controller = UserController.new
      controller.create(params)
    end

    context 'check params' do
      before do
        allow(User).to receive(:new).with(username: username, email: email, bio: bio)
          .and_return(user_stub)
      end

      context 'when params are valid' do
        let(:status) { 200 }

        it 'returns status 200' do
          allow(user_stub).to receive(:save).and_return(true)        

          controller = UserController.new
          response = controller.create(params)

          expect(response).to eq(expected_response)
        end
      end

      context 'when params are invalid' do
        let(:status) { 400 }

        it 'returns status 400' do
          allow(user_stub).to receive(:save).and_return(false)        

          controller = UserController.new
          response = controller.create(params)

          expect(response).to eq(expected_response)
        end
      end
    end
  end
end
