require_relative '../../services/attachment_uploader'

RSpec.describe 'AttachmentUploader' do
  let(:filename) { 'dummy.png' }
  let(:tempfile) { double }
  let(:base_url) { 'http://localhost:4567/' }
  let(:params) { { 'filename' => filename, 'tempfile' => tempfile, 'base_url' => base_url } }

  describe 'initialize' do
    context 'when params are valid' do
      it 'creates new AttachmentUploader object' do
        attachment_uploader = AttachmentUploader.new(params)

        expect(attachment_uploader.filename).to eq(filename)
        expect(attachment_uploader.tempfile).to eq(tempfile)
      end
    end

    context 'when params are invalid' do
      let(:params) { nil }

      it 'initialize class with nil' do
        attachment_uploader = AttachmentUploader.new(params)

        expect(attachment_uploader.filename).to eq(nil)
        expect(attachment_uploader.tempfile).to eq(nil)
      end
    end
  end

  describe '.upload' do
    let(:attachment_uploader) { AttachmentUploader.new(params) }
    let(:secure_random_string) { 'base64' }
    let(:secured_filename) { "#{secure_random_string}_#{filename}" }

    context 'when params are valid' do
      let(:file_path) { AttachmentUploader::BASE_FILE_PATH + secured_filename }
      let(:file_url) do
        attachment_uploader.base_url + AttachmentUploader::BASE_FILE_SUBPATH + secured_filename
      end
      let(:file_stub) { double }
      let(:tempfile_stub) { double }

      before do
        allow(File).to receive(:exist?).with(AttachmentUploader::BASE_FILE_PATH)
                                       .and_return(true)
        allow(SecureRandom).to receive(:urlsafe_base64).and_return(secure_random_string)
      end

      it 'uploads file into file_path' do
        expect(tempfile).to receive(:read).and_return(tempfile_stub)
        expect(File).to receive(:open).with(file_path, 'wb').and_yield(file_stub)
        expect(file_stub).to receive(:write).with(tempfile_stub)

        upload_url = attachment_uploader.upload
        expect(upload_url).to eq(file_url)
      end
    end

    context 'when params are invalid' do
      let(:filename) { [nil, ''].sample }
      let(:tempfile) { [nil, ''].sample }
      let(:base_url) { [nil, ''].sample }

      it 'does not upload file to file_path' do
        expect(File).not_to receive(:open)

        upload_url = attachment_uploader.upload
        expect(upload_url).to eq(nil)
      end
    end
  end
end
