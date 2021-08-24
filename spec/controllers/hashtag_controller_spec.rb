require_relative '../../controllers/hashtag_controller'

RSpec.describe 'HashtagController' do
  describe '.fetch_trendings' do
    let(:trending_results) do
      [
        { text: '#gigih1', hashtag_count: 50 },
        { text: '#semangat2', hashtag_count: 40 },
        { text: '#halo3', hashtag_count: 30 }
      ]
    end
    let(:data) { trending_results }
    let(:expected_response) do
      { status: 200, data: data }
    end

    before do
      allow(Hashtag).to receive(:find_trendings).and_return(trending_results)
    end

    it 'returns expected response' do
      controller = HashtagController.new
      response = controller.fetch_trendings
      expect(response).to eq(expected_response)
    end
  end
end
