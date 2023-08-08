require "sinatra"
require "sinatra/reloader" 
require "tilt/erubis"

root = File.expand_path("..", __FILE__)

get "/" do 
  @files = Dir.glob(root + '/data/*').map do |file|
    File.basename(file)
  end 

  erb :index  
end 

get "/:file" do 
  filepath = root + "/data/" + params[:file]
  
  headers["Content-Type"] = 'text/plain'

  File.read(filepath)
end 