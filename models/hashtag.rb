require_relative '../models/hashtag'

class Hashtag < Model
  attr_reader :id, :text

  def initialize(id=nil, text:)
    @id = id
    @text = text
  end

  def save
    return false if @text.nil?

    Hashtag.client.query("INSERT INTO hashtags(text) VALUES ('#{@text}')")
  end
end
