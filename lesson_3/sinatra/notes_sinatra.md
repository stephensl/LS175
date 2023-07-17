# Sinatra and Web Frameworks 

Sinatra is a Rack-based web development framework.
  - Rack-based means uses Rack to connect to a web server like WEBrick
  - provides conventions for placing application code
  - built-in capabilities for routing, view templates, etc. 

**At its core, Sinatra is nothing more than some Ruby code connecting to a TCP server, handling requests and sending back responses in a HTTP-compliant string format**

![server image](https://da77jsbdz4r05.cloudfront.net/images/working_with_sinatra/server-zoom-sinatra.png)

## Routes

Sinatra makes it simple to write Ruby code that runs when a user visits a particular URL.

DSL for defining routes

`get "/" do` is declaring a route that matches the URL `"/"`

When user visits the path on the application, Sinatra will execute the body of the block. The value returned by the block is sent to the user's browser. 

#

## Rendering Templates

View Templates are files containing text that is converted into HTML before being sent to a user's browser in a response. 

Many different templating languages
  - different ways to define what HTML to generate and how to embed dynamic values. 


Example: changing a page's `<title>` to be different on each page. 
  - dynamic value defined in Ruby code
  - inserted into template before sent to user

`ERB` is a templating language. (embedded Ruby)
  - embedding bits of Ruby code into another file. 
  - default templating language in Rails

```erb
<h1><% @title %></h1>
```

When template is rendered, value for `@title` will replace the `ERB` tags. 

**Any Ruby code at all can be placed in an `.erb` file by including it between `<%` and `%>`**

If you want to display a value, must use start tag `<%=`

#

To use the HTML template in the project as an ERB template instead:

copy code from html file to `views/home.erb`