ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

require_relative "../cms.rb"

class AppTest < Minitest::Test 
  include Rack::Test::Methods

  def app 
    Sinatra::Application
  end 

  def test_index
    get "/"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "history.txt"
    assert_includes last_response.body, "about.md"
    assert_includes last_response.body, "changes.txt"
  end
  
  def test_render_text_document
    get "/history.txt"
    assert_equal 200, last_response.status 
    assert_equal "text/plain", last_response["Content-Type"]
    assert_includes last_response.body, "1993 - Yukihiro Matsumoto dreams up Ruby." 
  end 

  def test_non_existent_document_redirect_and_message
    get "/notafile.txt"
    assert_equal 302, last_response.status 

    get last_response["Location"]
    assert_equal 200, last_response.status 
    assert_includes last_response.body, "notafile.txt does not exist."

    get "/"
    refute_includes last_response.body, "notafile.txt does not exist." 
  end 

  def test_viewing_markdown_document
    get "/about.md"

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "<h1>Ruby is...</h1>"
  end
end 