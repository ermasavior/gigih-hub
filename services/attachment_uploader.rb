require 'sinatra'

class AttachmentUploader
  def initialize
    @filename = nil
    @tempfile = nil
  end
end
