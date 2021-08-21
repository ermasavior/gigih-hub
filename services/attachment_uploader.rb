require 'securerandom'

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

    FileUtils.mkdir_p(BASE_FILE_PATH) unless File.exist?(BASE_FILE_PATH)

    file_path = BASE_FILE_PATH + secured_filename
    File.open(file_path, 'wb') do |f|
      f.write(tempfile.read)
    end

    base_url + BASE_FILE_SUBPATH + secured_filename
  end

  private

  def params_valid?
    return false if filename.nil? || filename == ''
    return false if tempfile.nil? || tempfile == ''
    return false if base_url.nil? || base_url == ''

    true
  end

  def secured_filename
    "#{SecureRandom.urlsafe_base64}_#{filename}"
  end
end
