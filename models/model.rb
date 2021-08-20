require_relative '../db/db_connector'

class Model
  def self.client
    @client ||= create_db_client
  end
end
