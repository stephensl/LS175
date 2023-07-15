# Persisting State in the URL

Create program that is simple counter. 

display number on screen

two links beneath
  - one to increase number by 1
  - one to decrease by 1


Using similar file from dice rolling program.

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

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts 
  client.puts "<htmL>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path 
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  client.puts "<p>The current number is #{number}.</p>"
  



  client.puts "</body>"
  client.puts "</html>"
  client.close 
end 
```

**Note** 

HTTP is a stateless protocol. Below we have a number that needs to be updated. Information must be provided in URL. 

```ruby
client.puts "<p>The current number is #{number}.</p>"
```

```ruby 
require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")

  params = (params || "").split("&").each_with_object({}) do |pair, hash|
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

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts 
  client.puts "<htmL>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path 
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number+1}'>Increment</a>"

  client.puts "<a href='?number=#{number-1}'>Decrement</a>"

  client.puts "</body>"
  client.puts "</html>"
  client.close 
end 
```


**Here we are able to simulate state by creating URLs and making sure any links manipulate parameters properly.**