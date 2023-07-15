# Empty Requests

May cause error with server side code, eg. `nil` values. 

Making connection with server, but not sending any data. 

example: 

```ruby 
 next if !request_line || request_line =~ /favicon/
```