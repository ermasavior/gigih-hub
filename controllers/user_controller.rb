require_relative '../models/user'

class UserController
  def create(params)
    user = User.new(
      username: params['username'], email: params['email'], bio: params['bio']
    )
    save_success = user.save

    return { status: 200, data: user.to_hash } if save_success

    { status: 400, data: nil }
  end
end
