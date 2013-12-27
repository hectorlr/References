class InformationController < ApplicationController
  def index
    @about = matrix.getAboutOutput
    @written = matrix.getWrittenOutput
    @stats = matrix.getStatistics
    @highly = matrix.getHighly
    @top = matrix.getTop
  end

  def downloadInformationFile
    matrix.createInformationFile
    send_file Rails.root.join('public', 'uploads', 'Information.txt'), :type => 'application/text'
  end
end