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
    let(:expected_query) { "INSERT INTO hashtags(text) VALUES ('#{hashtag_text}')" }

    context 'when params are valid' do
      context 'when hashtag is unique' do
        before do
          allow(Hashtag).to receive(:find_by_text).with(hashtag_text)
            .and_return(nil)
        end

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

        it 'initialize id with last id' do
          id = 1
          allow(Hashtag.client).to receive(:query).with(expected_query)
          allow(Hashtag.client).to receive(:last_id).and_return(id)

          hashtag = Hashtag.new(text: hashtag_text)
          hashtag.save
          expect(hashtag.id).to eq(id)
        end
      end

      context 'when hashtag already exists' do
        let(:existing_hashtag) { Hashtag.new(1, text: hashtag_text) }

        before do
          allow(Hashtag).to receive(:find_by_text).with(hashtag_text)
            .and_return(existing_hashtag)
        end

        it 'does not insert new hashtag query' do
          expect(Hashtag.client).not_to receive(:query)

          hashtag = Hashtag.new(text: hashtag_text)
          hashtag.save
        end

        it 'returns false' do
          hashtag = Hashtag.new(text: hashtag_text)
          expect(hashtag.save).to eq(false)
        end

        it 'initialize id with existing hashtag id' do
          allow(Hashtag.client).to receive(:query).with(expected_query)

          hashtag = Hashtag.new(text: hashtag_text)
          hashtag.save
          expect(hashtag.id).to eq(existing_hashtag.id)
        end
      end
    end

    context 'when params are invalid' do
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
    let(:expected_hashtags) {
      hashtag_texts.map { |text| Hashtag.new(text: text) }
    }

    context 'when post_text contains unique hashtags' do
      let(:post_text) { "#halo #kawula #muda" }
      let(:hashtag_texts) { ["#halo", "#kawula", "#muda"] }

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

      it 'returns empty array' do
        hashtags = Hashtag.extract_hashtags(post_text)
        expect(hashtags).to eq([])
      end
    end

    context 'when post_text is nil' do
      let(:post_text) { nil }
      let(:hashtag_texts) { [] }

      it 'returns empty array' do
        hashtags = Hashtag.extract_hashtags(post_text)
        expect(hashtags).to eq([])
      end
    end
  end

  describe '.find_by_text' do
    let(:hashtag_text) { "gigih" }

    context 'when hashtag is found' do
      before do
        Hashtag.new(text: hashtag_text).save
      end

      it 'returns hashtag' do
        hashtag = Hashtag.find_by_text(hashtag_text)
        expect(hashtag.text).to eq(hashtag_text)
      end

      after do
        Hashtag.client.query("DELETE FROM hashtags WHERE text='#{hashtag_text}'")
      end
    end

    context 'when hashtag is not found' do
      it 'returns nil' do
        hashtag = Hashtag.find_by_text(hashtag_text)
        expect(hashtag).to eq(nil)
      end
    end
  end
end
