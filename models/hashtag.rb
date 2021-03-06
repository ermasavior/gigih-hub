require_relative '../models/model'

class Hashtag < Model
  attr_reader :id, :text

  def initialize(id = nil, text:)
    @id = id
    @text = text
  end

  def to_hash
    {
      id: @id, text: @text
    }
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

  # rubocop:disable Metrics/MethodLength
  def self.find_trendings
    raw_data = Hashtag.client.query("
      SELECT hashtags.text, COUNT(*) AS hashtag_count
      FROM hashtags
      INNER JOIN post_hashtags ON hashtags.id = post_hashtags.hashtag_id
      INNER JOIN posts ON posts.id = post_hashtags.post_id
      WHERE posts.created_at >= now() - INTERVAL 1 DAY
      GROUP BY hashtags.id
      ORDER BY COUNT(*) DESC
      LIMIT 5
    ")

    results = []
    raw_data.each do |result|
      results << { text: result['text'], hashtag_count: result['hashtag_count'] }
    end
    results
  end
  # rubocop:enable Metrics/MethodLength
end
