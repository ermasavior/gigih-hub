require 'sinatra'
require_relative 'controllers/user_controller'
require_relative 'controllers/post_controller'

get '/' do
  return "Hello World from Gigih Hub API"
end

post '/api/users' do
  controller = UserController.new
  controller.create(params)
end

post '/api/posts' do
  controller = PostController.new
  controller.create(params)
end

after do
  response.body = JSON.dump(response.body)
end
