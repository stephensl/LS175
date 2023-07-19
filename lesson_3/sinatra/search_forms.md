# Adding a Search Form

Thus far, we've worked with parameters that are extracted from the URL. 

Two other ways to get data into the `params` hash:
  1. Using query parameters in the URL 
  2. Submitting a form using a `POST` request


Add search form that allows user to find chapters that match a given phrase. 

Reminder on Forms: 

- When a form is submitted, the browser makes a HTTP request.

- This request is made to the path or URL specified in the `action` attribute of the `form` element.

- The `method` attribute of the `form` determines if the request made will use `GET` or `POST`.

- The value of any `input` elements in the `form` will be sent as parameters. 
  - The keys of these parameters will be determined by the `name` attribute of the corresponding `input` element.

#

1. Add a new route, `"/search"`, to the application. 
  
  Within that route, render a new template, inside of which should be the following HTML:

  ```html
  
  ```
