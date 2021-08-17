require_relative '../models/hashtag'

class Hashtag < Model
  attr_reader :id, :text

  def initialize(id=nil, text:)
    @id = id
    @text = text
  end

  def save
    return false if @text.nil?
    return false unless self.unique?

    Hashtag.client.query("INSERT INTO hashtags(text) VALUES ('#{@text}')")
    true
  end

  def unique?
    hashtags = Hashtag.client.query("SELECT * FROM hashtags WHERE text='#{@text}'")
    hashtags.each.empty?
  end

  def self.extract_hashtags(post_text)
    return [] if post_text.nil?

    hashtag_texts = post_text.scan(/#\w+/)
    filtered_hashtag_texts = hashtag_texts.map(&:downcase).uniq

    filtered_hashtag_texts.map do |text|
      Hashtag.new(text: text)
    end
  end

  def self.find_by_text(text)
  end
end
