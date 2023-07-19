# Before Filters

Certain things must occur on every request to an application. 

In book viewer application we are loading the table of contents in both routes. 

```ruby 
get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")        # loading TOC

  erb :home
end

get "/chapters/:number" do
  @contents = File.readlines("data/toc.txt")        # loading TOC

  number = params[:number].to_i
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end
```

We can move code to a `before` filter in order to define it once in the program. 

Sinatra will run the code in a `before` filter before running the code in a matching route.
  - provides a good place for globally needed data. 

```ruby 
before do 
  @contents= File.readlines("data/toc.txt")
end 

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  
  erb :home
end

get "/chapters/:number" do 
  number = params[:number].to_i
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"
  
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter 
end 
```

Notice that the `@contents` instance variable is referenced by `views/layout.erb`. When a certain instance variable is referenced in a layout, the code that provides that variable is often a good candidate for a before filter. 

This isn't always the case, however, as even in this application `@title` is still defined in each of the routes. 

Since code in before filters run before all routes, instance variables defined within it are usually *not dependent* on which route is being executed. But the page title is dependent on which route is matched, and so we define it in each route instead of globally.

#
