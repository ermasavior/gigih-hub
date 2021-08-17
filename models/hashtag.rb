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
    true
  end

  def self.extract_hashtags(post_text)
    hashtag_texts = post_text.scan(/#\w+/)
    hashtag_texts.map do |text|
      Hashtag.new(text: text)
    end
  end
end
