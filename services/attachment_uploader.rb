class AttachmentUploader
  attr_reader :filename, :tempfile, :base_url

  BASE_FILE_SUBPATH = 'storage/'
  BASE_FILE_PATH = './public/' + BASE_FILE_SUBPATH

  def initialize(params)
    @filename = params['filename']
    @tempfile = params['tempfile']
    @base_url = params['base_url']
  end

  def upload
    file_path = BASE_FILE_PATH + filename
    File.open(file_path, 'wb') do |f|
      f.write(file.read)
    end

    base_url + BASE_FILE_SUBPATH + filename
  end
end
