require "sinatra"
require "sinatra/reloader" 
require "tilt/erubis"
require "redcarpet"

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end

def data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data", __FILE__)
  else 
    File.expand_path("../data", __FILE__)
  end 
end 

def render_markdown_content(content)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(content)
end 

def load_file_content(path)
  content = File.read(path)
  case File.extname(path)
  when ".txt"
    headers["Content-Type"] = "text/plain"
    content
  when ".md"
    erb render_markdown_content(content)
  end 
end 

get "/" do 
  @files = Dir.glob(data_path + '/*').map do |file|
    File.basename(file)
  end 

  erb :index  
end 

get "/:file" do 
  filepath = data_path + "/" + params[:file]
  
  if File.exist?(filepath)
    load_file_content(filepath)
  else 
    session[:message] = "#{params[:file]} does not exist."
    redirect "/"
  end 
end 

get "/:file/edit" do 
  filepath = File.join(data_path, params[:file])
  @filename = File.basename(filepath)
  @content = File.read(filepath)

  erb :edit
end 

post "/:file" do 
  filepath = File.join(data_path, params[:file])
  content = params[:content]
  File.write(filepath, content)

  session[:message] = "#{File.basename(filepath)} has been updated."
  redirect "/"
end 



