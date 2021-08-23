require 'sinatra'
require_relative 'controllers/user_controller'
require_relative 'controllers/post_controller'
require_relative 'controllers/hashtag_controller'

helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}/"
  end
end

get '/' do
  { status: 200, data: 'Hello World from Gigih Hub API' }
end

post '/api/users' do
  controller = UserController.new
  controller.create(params)
end

post '/api/posts' do
  params['attachment']['base_url'] = base_url if params&.key?('attachment')

  controller = PostController.new
  controller.create_post(params)
end

post '/api/posts/:id/comment' do
  params['attachment']['base_url'] = base_url if params&.key?('attachment')

  controller = PostController.new
  controller.create_comment(params)
end

get '/api/posts' do
  controller = PostController.new
  controller.fetch_by_hashtag(params)
end

get '/api/hashtags/trending' do
  controller = HashtagController.new
  controller.fetch_trendings
end

after do
  response.status = response.body[:status]
  response.body = JSON.dump(response.body)
end
