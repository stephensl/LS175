require "socket"

server = TCPServer.new("localhost", 3003) # server will accept requests sent to localhost, port number 3003
  loop do 
    client = server.accept   # waits until request comes in, accepts and returns client object

    request_line = client.gets
    puts request_line        # prints request to console 

    client.puts request_line  # send back to client so displayed in web browser
    client.close # close connection
  end 
