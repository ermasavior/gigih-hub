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
end
