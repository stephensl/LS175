# Layouts 

Duplication between the view templates `home.erb` and `chapter.erb`

Layouts are view templates that wrap around other view templates. 

Shared HTML code can go into layout so only particular view template code can go in specific view files. 

Example: 

```html
<html>
  <head>
    <title>Is it your birthday?</title>
  </head>
  <body>
    <p>Yes, it is!</p>
  </body>
</html>
```

Create a layout:

```html
<html>
  <head>
    <title>Is it your birthday?</title>
  </head>
  <body>
    <%= yield %>     <!-- added -->
  </body>
</html>
```

Now view template looks like: 
```html
<p>Yes, it is!</p>
```

**`yield` keyword used in layout to indicate where the content from the view template will go.**


Specify which layout to use by passing additional argument to `erb` call:

```ruby
get '/' do 
  erb :index, layout: :post
end 
```
Sinatra will look for a layout called `post.erb` in the `views` directory, and use this to wrap the `index.erb` template. 

If not specified, will default to `layout.erb`, and if does not exist, will render without a layout. 

#
#

# Creating layout for book viewer app


`views/layout.erb`
```html
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title><%= @title %></title>

    <link rel="stylesheet" href="/stylesheets/pure-min.css">
    <link rel="stylesheet" href="/stylesheets/fonts.css">
    <link rel="stylesheet" href="/stylesheets/book_viewer.css">
  </head>

  <body>
    <div id="layout">
      <a href="#menu" id="menuLink" class="menu-link"><span></span></a>

      <div id="menu">
        <div class="pure-menu">
          <a class="pure-menu-heading" href="/">Table of Contents</a>

          <ul class="pure-menu-list">
            <% @contents.each do |chapter| %>
              <li class="pure-menu-item">
                <a href="#" class="pure-menu-link"><%= chapter %></a>
              </li>
            <% end %>
          </ul>
        </div>
      </div>

      <div id="main">
        <div class="header">
          <h1>The Adventures of Sherlock Holmes</h1>
          <h2>by Sir Arthur Doyle</h2>
        </div>

        <div class="content">
          <%= yield %>
        </div>
      </div>
    </div>

    <script type="text/javascript" src="javascripts/ui.js"></script>
  </body>
</html>
```

`views/home.erb`
```html
<h2 class="content-subhead">Table of Contents</h2>

<div class="pure-menu">
  <ul class="pure-menu-list">
    <% @contents.each do |chapter| %>
      <li class="pure-menu-item">
        <a href="#" class="pure-menu-link"><%= chapter %></a>
      </li>
    <% end %>
  </ul>
</div>
```

`views/chapter.erb`
```html
<h2 class="content-subhead">Chapter 1</h2>

<%= @chapter %>
```