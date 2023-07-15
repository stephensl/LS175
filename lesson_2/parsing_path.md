# Parsing Path and Parameters

Requests made to server similar to function calls in that we can provide arguments and the server provides a response based on arguments passed. 

What info do we need to send to server for request?

Simplest way to pass info into program running on web is to use URL

We are providing `GET /` as request to the server. 

scheme host port path parts of URL 


pass data to program: 
  - using parameters (query parameters)
  - after `?` treated as parameter
  - add additional parameters using `&`

  `GET /?rolls=2sides=6 HTTP/1.1` We write Ruby code to parse this

  We want variables that will contain different values in the line. 

    - `http_method == "GET"`
    - `path == "/"`
    - `params = { "rolls" => "2", "sides" => "6" }`

  Separate into component parts: 

  ```http_method, path_and_params, http = request_line.split(" ")```


```ruby
require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")

  params = params.split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end 

  [http_method, path, params]
end 

server = TCPServer.new("localhost", 3003)
loop do 
  client = server.accept 

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  http_method, path, params = parse_request(request_line)

  client.puts request_line
  client.puts http_method
  client.puts path 
  client.puts params

  rolls = params["rolls"].to_i 
  sides = params["sides"].to_i 

  rolls.times do 
    roll = rand(sides) + 1
    client.puts roll 
  end 

  client.close 
end 
```

#