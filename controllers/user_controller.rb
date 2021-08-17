require_relative '../models/user'

class UserController
  def create(params)
    user = User.new(
      username: params['username'], email: params['email'], bio: params['bio']
    )
    user.save
  end
end
