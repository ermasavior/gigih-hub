require_relative '../../models/hashtag'

RSpec.describe 'Hashtag' do
  describe 'initialize' do
    let(:hashtag_text) { "GenerasiGIGIH" }

    it 'creates new hashtag' do
      hashtag = Hashtag.new(text: hashtag_text)

      expect(hashtag.text).to eq(hashtag_text)
    end
  end
end
