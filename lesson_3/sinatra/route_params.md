# Route Parameters

Adding pages for each chapter in the book. 

Use this pattern: 
`/chapters/1` will show chapter 1
`/chapters/2` will show chapter 2 
...

We can create a single route to handle all of them via adding *parameters* to URL pattern

`get "/chapters/:number" do end`

This matches any route that starts with `/chapters/` followed by a single segment. 

In most cases, segment will be an identifier to indicate which chapter to view.

Values passed to the application through the URL in this way appear in the `params` Hash that is automatically available in routes. 