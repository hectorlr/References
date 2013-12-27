class UploadController < ApplicationController
  #include Mongo
  #db = MongoClient.new("ds047468.mongolab.com", 47468).db("references")
  # auth = db.authenticate('admin', 'root')
  # coll = db.collection("testCollection")
  # doc = {"name" => "MongoDB", "type" => "database", "count" => 1, "info" => {"x" => 203, "y" => '102'}}
  #id = coll.insert(doc)
  def index
  end

  def onUpload
    if !params[:upload].nil?
      uploaded_io = params[:upload][:datafile]
      puts(uploaded_io)
      File.open(Rails.root.join('public', 'uploads', 'GraphDocTemp.txt'), 'w+') do |file|

        file.write(uploaded_io.read)
        file.close
        lines = []
        File.open(file.path, 'rb').each_line do |line|
          lines.push(line.strip)
        end
        matrix.buildGraph(lines)
      end
    else
      render 'upload/index'
    end
  end
end