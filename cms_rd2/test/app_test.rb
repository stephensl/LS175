ENV["RACK_ENV"] = "test"
require "fileutils"

require "minitest/autorun"
require "rack/test"

require_relative "../app"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    FileUtils.mkdir_p(data_path)
  end   
  
  def teardown
    FileUtils.rm_rf(data_path)
  end 
  
  def create_document(name, content="")
    File.open(File.join(data_path, name), "w") do |file|
      file.write(content)
    end 

  def session 
    last_request.env["rack.session"]
  end 
  end 

  def test_index
    create_document("changes.txt")
    create_document("about.txt")
    create_document("history.txt")

    get "/"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "changes.txt"
    assert_includes last_response.body, "about.txt"
    assert_includes last_response.body, "history.txt"
  end

  def test_view_file_content
    create_document("changes.txt", "If we compare land animals")
    
    get "/changes.txt"

    assert_equal 200, last_response.status 
    assert_equal "text/plain", last_response["Content-Type"]
    assert_includes last_response.body, "If we compare land"
  end 

  def test_file_does_not_exist
    create_document("changes.txt")
    create_document("history.txt")

    get "/notafile.txt"

    assert_equal 302, last_response.status 
    
    get last_response["Location"]

    assert_equal 200, last_response.status 
    assert_includes last_response.body, "notafile.txt does not exist"
    
    get "/"
    refute_includes last_response.body, "notafile.txt does not exist"
  end 

  def test_render_markdown_file_as_html
    create_document("mark.md", "# Headline")

    get "/mark.md"

    assert_equal 200, last_response.status 
    assert_includes last_response.body, "<h1>Headline</h1>"
  end 

  def test_edit_file
    create_document("test.txt", "L is for the way you...")

    get "/test.txt/edit"
    assert_equal 200, last_response.status 
    assert_includes last_response.body, "L is for the"

    post "/test.txt", { content: "look at me" }
    assert_equal 302, last_response.status 
    assert_equal "test.txt has been updated.", session[:message]

    get "/test.txt"
    assert_equal 200, last_response.status 
    assert_includes last_response.body, "look at me"
  end 


end