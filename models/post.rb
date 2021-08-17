require_relative '../models/model'

class Post < Model
  attr_accessor :id, :text, :created_at, :user

  def initialize(id=nil, created_at=nil, text:, user:)
  end
end
