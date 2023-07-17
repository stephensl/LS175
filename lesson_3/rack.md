# Rack 

Rack is a generic interface to help application developers connect to web servers. 

We are essentially replacing our TCP server with WEBrick and RUby code with a Rack application. 

![Server Image](https://da77jsbdz4r05.cloudfront.net/images/working_with_sinatra/server-zoom-rack.png)

When working with Rack applications, entire server is comprised of the Rack application adn a web server (WEBrick in this case). 

*Most developers wouldn't write Rack applications except for the simplest of situations*

![Rack image](https://miro.medium.com/v2/resize%253Afit%253A720/format%253Awebp/1%252ADofQK76mEgR-zLcsDlTpFw.png)

##

##


# Blog Series on Rack: Part 1
https://launchschool.medium.com/growing-your-own-web-framework-with-rack-part-1-8c4c630c5faf


## What is Rack 
Rack is essentially a contract between web servers and web applications written in Ruby. It provides a consistent API that allows web servers and web applications to communicate with each other. This API is based around a single method, call, which accepts an environment hash (representing the incoming HTTP request) and returns an array (representing the HTTP response).

### What problem does it solve?

Before rack when developers wanted to write a web application in ruby they needed to specifically tailor their code to the server they were planning to use. This is because each server had its own way of dealing with requests and responses. For example the way you'd write an application for the `WEBrick` server would be different from how you'd write it for the `unicorn` server. It was like having a universal remote that could only control one brand of television. 

This was a big problem for the developers of web frameworks like `rails` or `sinatra` as they wanted their frameworks to be usable with any server, but supporting a new server meant writing a lot of server specific code.

Rack provided a standard way for servers and applications to communicate. With Rack, it doesn't matter what server you're using. As long as the server and the application both speak Rack, they can understand each other.

Rack is like a universal translator in the world of Ruby web development. 
Rack
- takes a request from the server, 
- translates it into a format the application can understand (a Ruby hash), 
- lets the application process the request and generate a response, 
- translates the response back into a format the server can understand (an array with status, headers, and body).

### What makes a Rack Application

1. Create "rackup" file
  - configuration file that specifies what to run and how to run it. 
    - uses file extension `.ru`

2. Rack application sed in teh rackup file must be a Ruby object that responds to the `call(env)` method. 
  - the `call` method takes one argument, which is the environment variables for the application. 

3. `call` method always returns an array containing 3 elements:
  - Status code: string or other data type that responds to `to_i`
  - Headers
    - key/value pairs inside a hash. 
    - key is header name
    - value is value for that header
  - Response body
    - anything as long as can respond to `each` method. 
    - should never be String by itself, but must `yield` a String value.

*These 3 elements represent info used to put together the response sent back to the client.* 

#

## `config.ru`

```ruby 
require_relative 'hello_world'

run HelloWorld.new
```

## `hello_world.rb`

```ruby
class HelloWorld
  def call(env)
    ['200', {'Content-Type' => 'text/plain'}, ['Hello World!']]
  end 
end 
```
#### Requirements met for Rack Application:
- We have a configuration file that tells the server what to run (the config.ru file). 

- We also have the application itself, the HelloWorld class in the hello_world.rb file. 

- We know it is a Rack application because it has the method call(env), and that method returns a 3 element array containing the exact information needed for a proper Rack application: 
  - a status code (string), 
  - headers (hash),
  - a response body (responds to `each`).


### Starting the Rack application

```bundle exec rackup config.ru -p 9595```
  - `-p` flag
    - allows specification of port
      - can use any between 0-65535
      - if not specified, default to 9292 with `rackup`

#
#
#

# Blog Series on Rack: Part 2

## Routing: adding pages to application 

Creating new class: 

```ruby 
class Advice
  def initialize
    @advice_list = [
      "Look deep into nature, and then you will understand everything better.",
      "I have found the paradox, that if you love until it hurts, there can be no more hurt, only more love.",
      "What we think, we become.",
      "Love all, trust a few, do wrong to none.",
      "Oh, my friend, it's not what they take away from you that counts. It's what you do with what you have left.",
      "Lost time is never found again.",
      "Nothing will work unless you do."
    ]
  end 

  def generate
    @advice_list.sample
  end 
end 
```
The class above is not a separate web application like `HelloWorld`. Notice, that it doesn't have a `call` method. 

This class will be solely used for content generation in our web application.  

### Routing

we can use the environment variable `REQUEST_PATH` to specify which URL to navigate to. 
  - if request path specifies `/` we show usual `"Hello World!"` message.
  - if request request path specifies `/advice`, reply with random piece of advice. 

*We also add in one more route to handle non-existent pages with `404` message.*

```ruby
# hello_world.rb

require_relative 'advice'   # loads advice.rb

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when `/`
      ['200', {"Content-Type" => 'text/plain'}, ["Hello world!"]]
    when '/advice'
      piece_of_advice = Advice.new.generate
      ['200', {"Content-Type" => 'text/plain'}, [piece_of_advice]]
    else 
      [
        '404',
        {"Content-Type" => 'text/plain', "Content-Length" => '13'}, ["404 Not Found"]
      ]
    end 
  end 
end 
```

#

## Adding HTML to Response Body

- Make “Hello World!” an h2 header.
- Italicize and bold our advice. 
- For the 404 page, we’ll make it an h4.

```ruby 
require_relative 'advice' 

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      ['200', {"Content-Type" => 'text/html'}, ["<html><body><h2>Hello world!</h2></body></html>"]]
    when '/advice'
      piece_of_advice = Advice.new.generate
      ['200', {"Content-Type" => 'text/html'}, ["<html><body><b><em>#{piece_of_advice}</em></b></body></html>"]]
    else 
      [
        '404',
        {"Content-Type" => 'text/html', "Content-Length" => '48'}, ["<html><body><h4>404 Not Found</h4></body></html>"]
      ]
    end 
  end 
end 
```

#
#

# Blog Series on Rack: Part 3

Learning how to separate out our application logic from our view-related code. 
  - makes more modular/manageable

Introduction of `ERB` library
  - helps turn Ruby code into HTML.

#

## View Templates

Need location in application to store and maintain code related to what we want to display.

View templates are separate files that allow us to do some pre-processing on server side in a programming language, then translate programming code into a string to rerun to the client (usually HTML). 


## `ERB`

Embedded Ruby- allows us to embed Ruby directly into HTML. 

ERB library can process special syntax that mixes RUby into HTML and produces final 100% HTML string. 

`<%= %>` are ERB tags used to execute RUby code that is embedded within a string. 

Two Types: 
  - `<%= %>`
    - evaluates embedded Ruby code, and include its return value in the HTML output.
    - useful for method invocations
  - `<% %>`
    - only evaluates Ruby code
    - does NOT include return value in HTML output
    - Useful if want to evaluate Ruby code, but don't want to include return value in final string. 
      - method definition good use case. 

### ERB to process entire files, not just strings. 

```erb
# example.erb

<% names = %w(bob joe kim jill) %>

<html>
  <body>
    <h4>Hello, my name is <%= names.sample %>
  </body>
</html>
```
If we had an `.rb` file in the same directory as the `example.erb` file above, we could process that erb file like this:

```ruby
require 'erb'

template_file = File.read('example.erb')
erb = ERB.new(template_file)
erb.result
```

Result would be:

```html
<html><body><h4>Hello, my name is jill</h4></body></html>
```

#
#

## Adding in View Templates
Create a view template for the information we wish to display to the user. 

This will be the default view template for our application, `index.erb`. 

We also have to include the same message we've been using for our root route: `"Hello World!"`.

```views/index.erb```

```erb
<html>
  <body>
    <h2>Hello World!</h2>
  </body>
</html>
```

We need to read it into our application and use it. 

We can treat it just like any other file and use the `.read` method from the Ruby File class.

```ruby
# hello_world.rb

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      template = File.read("views/index.erb")
      content = ERB.new(template)
      ['200', {"Content-Type" => "text/html"}, [content.result]]
    when '/advice'
      piece_of_advice = Advice.new.generate
      [
        '200',
        {"Content-Type" => 'text/html'},
        ["<html><body><b><em>#{piece_of_advice}</em></b></body></html>"]
      ]
    else
      [
        '404',
        {"Content-Type" => 'text/html', "Content-Length" => '48'},
        ["<html><body><h4>404 Not Found</h4></body></html>"]
      ]
    end
  end
end
```

Above, we took a string value (contents of `index.erb`) and pass that in `ERB.new`.

Then we use the `#result` method to get 100% HTML string output for the response body. We are getting the string value from a file (the view template).

**For this particular page, we don’t actually need ERB. There isn’t any dynamic content related to our index page. Yet, we’ll need it for the routes that require dynamic data, so to keep everything consistent, we’ll be using .erb files for all our other routes. This also leaves options open for us; if we want to add dynamic content to index.erb later, then we can easily do so.**

#
#
#

## Blog Series on Rack: Part 4
*continue to separate out the view related code for our other routes, and then finally, we'll extract some more general purpose methods to a framework.*

#

### Cleaning up the `call` method
Originally, `call` method purely focused on interacting with the request, and handling the response. 
  - now we have code related to reading in files and setting up a templating object (not directly related to request/response)

Let's move this code to its own method, then we can use this method from within our `call` method. 

Updated `call` method pre-implementation of `erb` method. 

- We pass the `erb` method a symbol, signifying which template to render. 

```ruby 
# hello_world.rb
def call(env)
  case env['REQUEST_PATH']
  when '/'
    ['200', {"Content-Type" => "text/html"}, [erb(:index)]]
  when '/advice'
    piece_of_advice = Advice.new.generate
    [
      '200',
      {"Content-Type" => 'text/html'},
      ["<html><body><b><em>#{piece_of_advice}</em></b></body></html>"]
    ]
  else
    [
      '404',
      {"Content-Type" => 'text/html', "Content-Length" => '48'},
      ["<html><body><h4>404 Not Found</h4></body></html>"]
    ]
  end
end
```
We then use the return value from the erb method as our response body. 

```ruby
def erb(filename)
  content = File.read("views/#{filename}.erb")
  ERB.new(content).result
end 
```

Current full application:

```ruby 
# hello_world.rb
class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      ['200', {"Content-Type" => "text/html"}, [erb(:index)]]
    when '/advice'
      piece_of_advice = Advice.new.generate
      [
        '200',
        {"Content-Type" => 'text/html'},
        ["<html><body><b><em>#{piece_of_advice}</em></b></body></html>"]
      ]
    else
      [
        '404',
        {"Content-Type" => 'text/html', "Content-Length" => '48'},
        ["<html><body><h4>404 Not Found</h4></body></html>"]
      ]
    end
  end  private  def erb(filename)
    content = File.read("views/#{filename}.erb")
    ERB.new(content).result
  end
end
```


## Adding more View Templates

Need templates for `advice` and `not found` pages.

```views/advice.erb```

```erb
<html>
  <body>
    <p><em><%= message %></em></p>
  </body>
</html>
```

```views/not_found.erb```

```erb
<html>
  <body>
    <h2>404 Not Found</h2>
  </body>
</html>
```

Full app code: 

```ruby 
require_relative 'advice' 

class App
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = '200'
      headers = {"Content-Type" => 'text/html'}
      response(status, headers) do 
        erb(:index)
      end 
    when '/advice'
      piece_of_advice = Advice.new.generate
      status = '200'
      headers = {"Content-Type" => 'text/html'}
      response(status, headers) do   
        erb(:advice, message: piece_of_advice)
      end 
    else 
      status = '404',
      headers= {"Content-Type" => 'text/html', "Content-Length" => '61'}
      response(status, headers) do 
        erb(:not_found)
      end 
    end 
  end 

  private 

  def response(status, headers, body = '')
    body = yield if block_given?
    [status, headers, [body]]
  end 

  def erb(filename, local = {})
    b = binding
    message = local[:message]
    content = File.read("views/#{filename}.erb")
    ERB.new(content).result(b)
  end 
end 
```

#

## Start of Framework 

If wanted to make another web app, or integrate two or more apps within larger one, we''d need to redefine certain general purpose methods in each app. 

This is when frameworks come into picture as they hold the common methods that we may want to use between different applications. 

`response` and `erb` are prime candidates for framework. 

Framework will be located in `monroe.rb`

```ruby 
class Monroe 
  def erb(filename, local = {})
    b = binding 
    message = local[:message]
    content = File.read("views/#{filename}.erb")
    ERB.new(content).result(b)
  end 

  def response(status, headers, body = "")
    body = yield if block_given?
    [status, headers, [body]]
  end 
end 
```

The methods are removed from `app.rb`, and here is remaining code.

```ruby
require_relative 'monroe'
require_relative 'advice' 

class App < Monroe
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = '200'
      headers = {"Content-Type" => 'text/html'}
      response(status, headers) do 
        erb(:index)
      end 
    when '/advice'
      piece_of_advice = Advice.new.generate
      status = '200'
      headers = {"Content-Type" => 'text/html'}
      response(status, headers) do   
        erb(:advice, message: piece_of_advice)
      end 
    else 
      status = '404',
      headers= {"Content-Type" => 'text/html', "Content-Length" => '60'}
      response(status, headers) do 
        erb(:not_found)
      end 
    end 
  end 
end 
```

