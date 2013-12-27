class DownloadController < ApplicationController
  def index

  end

  def download
    fileName = params[:post][:fileName]
    File.open(Rails.root.join('tempFiles', fileName + '.txt'), 'w+') do |file|
      file.write(File.read(Rails.root.join('public', 'uploads', 'GraphDoc.txt')))
      file.close()
      send_file file.path, :type => 'application/text'
    end
  end
end