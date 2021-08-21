require_relative '../../services/attachment_uploader'

RSpec.describe 'AttachmentUploader' do
  let(:filename) { 'dummy.png' }
  let(:tempfile) { double }
  let(:base_url) { 'http://localhost:4567/' }
  let(:params) { { 'filename' => filename, 'tempfile' => tempfile, 'base_url' => base_url } }

  describe 'initialize' do
    it 'creates new AttachmentUploader object' do
      attachment_uploader = AttachmentUploader.new(params)

      expect(attachment_uploader.filename).to eq(filename)
      expect(attachment_uploader.tempfile).to eq(tempfile)
    end
  end

  describe '.upload' do
    let(:attachment_uploader) { AttachmentUploader.new(params) }
    let(:file_path) { AttachmentUploader::BASE_FILE_PATH + attachment_uploader.filename }
    let(:file_url) do
      attachment_uploader.base_url + AttachmentUploader::BASE_FILE_SUBPATH + attachment_uploader.filename
    end

    context 'when params are valid' do
      it 'uploads file into file_path' do
        expect(File).to receive(:open).with(file_path, 'wb')

        upload_url = attachment_uploader.upload
        expect(upload_url).to eq(file_url)
      end
    end
  end
end
