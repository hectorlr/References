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
      uploaded_io = params[:upload]['datafile']
      puts(uploaded_io)
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), "w+") do |file|

        file.write(uploaded_io.read)
        file.close
        @fileOuput = File.open(file.path).read
        matrix = AdjacencyMatrix.new
        lines = IO.readlines(file.path)
        matrix.buildGraph(lines)
        @fileOuput = matrix.adjacencyMatrix
      end
    else
      render 'upload/index'
    end
  end
end