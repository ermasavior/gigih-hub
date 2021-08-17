require_relative '../../models/hashtag'

RSpec.describe 'Hashtag' do
  let(:hashtag_text) { "GenerasiGIGIH" }

  describe 'initialize' do
    it 'creates new hashtag' do
      hashtag = Hashtag.new(text: hashtag_text)

      expect(hashtag.text).to eq(hashtag_text)
    end
  end

  describe '.save' do
    context 'when params are valid' do
      let(:expected_query) { "INSERT INTO hashtags(text) VALUES ('#{hashtag_text}')" }

      it 'triggers insert new hashtag query' do
        expect(Hashtag.client).to receive(:query).with(expected_query).once
        
        hashtag = Hashtag.new(text: hashtag_text)
        hashtag.save
      end
    end
  end
end
