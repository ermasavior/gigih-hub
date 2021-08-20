require_relative '../db/db_connector'

class Model
  def self.client
    @client ||= create_db_client
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end
