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

  describe '.extract_hashtags' do
    context 'when post_text contains unique hashtags' do
      let(:post_text) { "#halo #kawula #muda" }
      let(:hashtag_texts) { ["#halo", "#kawula", "#muda"] }
      let(:expected_hashtags) {
        hashtag_texts.map { |text| Hashtag.new(text: text) }
      }

      it 'returns array of hashtags' do
        hashtags = Hashtag.extract_hashtags(post_text)
        hashtags.zip(expected_hashtags) do |hashtag, expected|
          expect(hashtag.text).to eq(expected.text)
        end
      end
    end

    context 'when post_text contains duplicate hashtags' do
      let(:post_text) { "Mari menyanyi #halo #halo #bandung" }
      let(:hashtag_texts) { ["#halo", "#bandung"] }
      let(:expected_hashtags) {
        hashtag_texts.map { |text| Hashtag.new(text: text) }
      }

      it 'returns array of hashtags uniquely' do
        hashtags = Hashtag.extract_hashtags(post_text)
        hashtags.zip(expected_hashtags) do |hashtag, expected|
          expect(hashtag.text).to eq(expected.text)
        end
      end
    end

    context 'when post_text contains hashtags with camel cases' do
      let(:post_text) { "Mari menyanyi #HaLo #haLo #bandung" }
      let(:hashtag_texts) { ["#halo", "#bandung"] }
      let(:expected_hashtags) {
        hashtag_texts.map { |text| Hashtag.new(text: text) }
      }

      it 'returns array of unique hashtags in lower case' do
        hashtags = Hashtag.extract_hashtags(post_text)
        hashtags.zip(expected_hashtags) do |hashtag, expected|
          expect(hashtag.text).to eq(expected.text)
        end
      end
    end

    context 'when post_text does not contain hashtags' do
      let(:post_text) { "Mari menyanyi Halo Halo Bandung" }
      let(:hashtag_texts) { [] }
      let(:expected_hashtags) {
        hashtag_texts.map { |text| Hashtag.new(text: text) }
      }

      it 'returns empty array' do
        hashtags = Hashtag.extract_hashtags(post_text)
        expect(hashtags).to eq([])
      end
    end
  end
end
