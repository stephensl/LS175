require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"


get "/" do 
  @files = Dir.glob("public/*").map { |file| File.basename(file)}
 
end 