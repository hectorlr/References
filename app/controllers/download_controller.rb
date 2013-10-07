class DownloadController < ApplicationController
  def index

  end
  def download
    fileName = params[:post][:fileName]

    send_file Rails.root.join('public', 'uploads', 'GraphDoc.txt'), :type=>'application/text'
  end
end