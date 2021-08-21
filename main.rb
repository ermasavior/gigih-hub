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

get '/api/posts' do
  controller = PostController.new
  controller.fetch_by_hashtag(params)
end

get '/api/hashtags/trending' do
  file_name = params['attachment']['filename']
  puts file_name
  file = params['attachment']['tempfile']
  file_path = "./public/storage/#{file_name}"
  puts base_url + file_name
  params[:attachment][:baseurl] = base_url if params.key?("attachment")
  puts params[:attachment][:baseurl]

  controller = HashtagController.new
  controller.fetch_trendings
end

after do
  response.body = JSON.dump(response.body)
end
