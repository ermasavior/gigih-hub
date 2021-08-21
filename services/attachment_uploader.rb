class AttachmentUploader
  attr_reader :filename, :tempfile, :base_url

  BASE_FILE_PATH = './public/storage/'

  def initialize(params)
    @filename = params['filename']
    @tempfile = params['tempfile']
    @base_url = params['base_url']
  end

  def upload
  end
end
