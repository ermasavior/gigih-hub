require 'sinatra'

class AttachmentUploader
  attr_reader :filename, :tempfile

  def initialize(params)
    @filename = params['filename']
    @tempfile = params['tempfile']
  end
end
