require 'sinatra'
require_relative 'controllers/user_controller'
require_relative 'controllers/post_controller'
require_relative 'controllers/hashtag_controller'

get '/' do
  return 'Hello World from Gigih Hub API'
end

post '/api/users' do
  controller = UserController.new
  controller.create(params)
end

post '/api/posts' do
  controller = PostController.new
  controller.create_post(params)
end

post '/api/posts/:id/comment' do
  controller = PostController.new
  controller.create_comment(params)
end

get '/api/hashtags/trending' do
  controller = HashtagController.new
  controller.fetch_trendings
end

after do
  response.body = JSON.dump(response.body)
end
