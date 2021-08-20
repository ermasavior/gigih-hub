require 'mysql2'

def create_db_client
  Mysql2::Client.new(
    host: ENV['HOST'],
    username: ENV['DB_USERNAME'],
    password: ENV['DB_PASSWORD'],
    database: ENV['DB_DATABASE']
  )
end
