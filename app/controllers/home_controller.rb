class HomeController < ApplicationController
  def index

  end

  def downloadErrorFile
      send_file Rails.root.join('public', 'uploads', 'Errors.txt'), :type => 'application/text'
  end
end