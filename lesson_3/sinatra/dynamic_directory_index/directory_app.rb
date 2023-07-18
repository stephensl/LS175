require "tilt/erubis"
require "sinatra"

get "/" do
  @order = params[:order] || 'asc'
  @files = Dir.glob("public/*").map { |file| File.basename(file)}.sort
  @files.reverse! if @order == 'desc'
  
  erb :home
end 

