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

      it 'returns true' do
        allow(Hashtag.client).to receive(:query).with(expected_query)

        hashtag = Hashtag.new(text: hashtag_text)
        expect(hashtag.save).to eq(true)
      end
    end

    context 'when params are valid' do
      let(:hashtag_text) { nil }

      it 'triggers insert new hashtag query' do
        expect(Hashtag.client).not_to receive(:query)
        
        hashtag = Hashtag.new(text: hashtag_text)
        hashtag.save
      end

      it 'returns false' do
        hashtag = Hashtag.new(text: hashtag_text)
        expect(hashtag.save).to eq(false)
      end
    end
  end
end
