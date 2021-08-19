require_relative '../models/hashtag'

class Hashtag < Model
  attr_reader :id, :text

  def initialize(id=nil, text:)
    @id = id
    @text = text
  end

  def save
    return false if @text.nil?

    hashtag = Hashtag.find_by_text(@text)
    unless hashtag.nil?
      @id = hashtag.id
      return false
    end

    Hashtag.client.query("INSERT INTO hashtags(text) VALUES ('#{@text}')")
    @id = Hashtag.client.last_id
    true
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
    raw_data = Hashtag.client.query("SELECT * FROM hashtags WHERE text='#{text}'")
    hashtag_result = raw_data.first
    return nil if hashtag_result.nil?

    Hashtag.new(hashtag_result['id'], text: hashtag_result['text'])
  end
end
