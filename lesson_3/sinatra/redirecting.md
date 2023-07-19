# Redirecting

1. How Sinatra handles requests for paths it doesn't have a route for. 

2. How to redirect user to another path. 


#

Sinatra provides a special route, `not_found`, that will be executed whenever it can't find any other route to match an incoming request with. 

This is commonly used to build custom "Page Not Found" pages. The return value of the `not_found` block is handled just like the return value of any other route.

```ruby 
not_found do 
  "Nothing to see here"
end 
```

Routes do not have to return HTML code that will be returned to the user's browser

They can also send the browser to a different URL using the `redirect` method in Sinatra.

`redirect "a/good/path"`

**It is common to redirect a user as the result of creating or updating some data, such as redirecting to confirmation page after a payment form is successfully submitted**

The `redirect` method sets the `Location` header in the HTTP response that is sent back to the client, as well as a status code in the range `3XX`, usually `301` or `302` used for redirection. 

The browser verifies the correct status (3??), looks at teh value of the header, and uses header value to navigate to new URL. 

#


For the book viewer project, we want to send users back to home page. 

```ruby
not_found do 
  redirect "/"
end 
```

#

There are also instances where we have to handle edge cases when accessing an existing route. 

It's possible to match a route with a path even if that path isn't valid.

For instance, we could try and access a non-existent book chapter or specify a non-number value where the chapter number should be. 

Those two cases aren't considered unknown paths, they're considered semantically incorrect paths. 

The following code is a possible fix for the two issues listed above.

```ruby 
get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect "/" unless (1..@contents.size).cover? number # added for edge cases

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end
```

#
