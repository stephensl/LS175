# View Helpers

Whitespace is ignored in HTML so to improve readability we can use a view helper. 

These are methods that are made available in templates by sinatra for:
  - filtering data
  - processing data 
  - performing some other functionality


View helpers are defined within a `helpers` block in a Sinatra app file

```ruby 
helpers do 
  def slugify(text)
    text.downcase.gsub(/\s+/, "-").gsub(/[^\w-]/, "")
  end 
end 
```

They can be used like any other method in a template:

`@title = "Today is the Day"`

```html
<a href="/articles/<%= slugify(@title) %"><%= @title %></a> 
```

Will render as: 

```html
<a href="/articles/today-is-the-day">Today is the Day</a>
```

##

We can use similar approach for formatting chapter text.

- Create a view helper called `in_paragraphs`. This method should take a string that is the chapter content and return the same string with paragraph tags wrapped around each non-empty line.