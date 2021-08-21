class AttachmentUploader
  attr_reader :filename, :tempfile, :base_url

  BASE_FILE_SUBPATH = 'storage/'.freeze
  BASE_FILE_PATH = "./public/#{BASE_FILE_SUBPATH}".freeze

  def initialize(params)
    return if params.nil?

    @filename = params['filename']
    @tempfile = params['tempfile']
    @base_url = params['base_url']
  end

  def upload
    return nil unless params_valid?

    file_path = BASE_FILE_PATH + filename
    File.open(file_path, 'wb') do |f|
      f.write(file.read)
    end

    base_url + BASE_FILE_SUBPATH + filename
  end

  private

  def params_valid?
    return false if filename.nil? || filename == ''
    return false if tempfile.nil? || tempfile == ''
    return false if base_url.nil? || base_url == ''

    true
  end
end
