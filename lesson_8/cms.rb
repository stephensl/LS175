require "sinatra"
require "sinatra/reloader" 
require "sinatra/content_for"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end

root = File.expand_path("..", __FILE__)

get "/" do 
  @files = Dir.glob(root + "/data/*").map do |path| 
    File.basename(path)
  end   

  erb :index
end 

get "/:filename" do 
  file_path = root + "/data/" + params[:filename]

  headers["Content-Type"] = "text/plain"
  
  File.read(file_path)
end 