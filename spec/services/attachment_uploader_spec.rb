require_relative '../../services/attachment_uploader'

RSpec.describe 'AttachmentUploader' do
  let(:filename) { 'dummy.png' }
  let(:tempfile) { double }
  let(:params) { { "filename" => filename, "tempfile" => tempfile } }

  describe 'initialize' do
    it 'creates new AttachmentUploader object' do
      attachment_uploader = AttachmentUploader.new(params)

      expect(attachment_uploader.filename).to eq(filename)
      expect(attachment_uploader.tempfile).to eq(tempfile)
    end
  end
end
