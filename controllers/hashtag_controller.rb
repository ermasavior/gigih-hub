require_relative '../models/hashtag'

class HashtagController
  def fetch_trendings
    hashtags = Hashtag.find_trendings
    {
      status: 200,
      data: hashtags.map { |hashtag| hashtag.to_hash }
    }
  end
end
