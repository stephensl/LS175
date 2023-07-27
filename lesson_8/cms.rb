require "sinatra"
require "sinatra/reloader" 
require "sinatra/content_for"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end

root = File.expand_path("..", __FILE__)

before do 
  @files = Dir.glob(root + "/data/*").map do |path| 
    File.basename(path)
  end 
end 

helpers do 
  def file_exists?(file)
    @files.include?(file)
  end 
end 

get "/" do 
  erb :index
end 

get "/:filename" do 
  file_path = root + "/data/" + params[:filename]

  headers["Content-Type"] = "text/plain"
  
  file = params[:filename]

  if file_exists?(file)
    File.read(file_path)
  else 
    session[:message] = "#{file} does not exist."
    redirect "/"
  end 
end 