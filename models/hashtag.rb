require_relative '../models/hashtag'

class Hashtag < Model
  attr_reader :id, :text

  def initialize(id=nil, text:)
  end
end
