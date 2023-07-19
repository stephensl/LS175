require 'yaml'

require "tilt/erubis"
require "sinatra"

before do 
  @user_list = YAML.load_file("data/users.yaml")
end 

helpers do 
  def count_interests(user_list)
    user_list.reduce(0) do |sum, (name, user)|
      sum + user[:interests].size  
    end
  end 
end 

get "/" do 
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
