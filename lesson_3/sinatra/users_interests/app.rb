require "tilt/erubis"
require "sinatra"
require 'yaml'

before do 
  @user_list = YAML.load_file("data/users.yaml")
end 

get "/" do 
  "Homepage"

  redirect "/users"
end 

get "/users" do 
  erb :list
end 

get "/users/:name" do 
  name = params[:name].to_sym

  if @user_list.has_key?(name)
    @name = name 
    @email = @user_list[name][:email]
    @interests = @user_list[name][:interests]
  else 
    "Not Found"
    redirect "/"
  end 

  erb :user_profile
end 
