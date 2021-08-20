require_relative '../../controllers/hashtag_controller'

RSpec.describe 'HashtagController' do
  describe '.fetch_trendings' do
    let(:hashtags) do
      [
        Hashtag.new(text: '#gigih1'),
        Hashtag.new(text: '#gigih2'),
        Hashtag.new(text: '#gigih3')
      ]
    end
    let(:data) { hashtags.map(&:to_hash) }
    let(:expected_response) do
      { status: 200, data: data }
    end

    before do
      allow(Hashtag).to receive(:find_trendings).and_return(hashtags)
    end

    it 'returns expected response' do
      controller = HashtagController.new
      response = controller.fetch_trendings
      expect(response).to eq(expected_response)
    end
  end
end
