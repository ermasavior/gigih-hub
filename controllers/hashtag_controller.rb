require_relative '../models/hashtag'

class HashtagController
  def fetch_trendings
    {
      status: 200,
      data: Hashtag.find_trendings
    }
  end
end
