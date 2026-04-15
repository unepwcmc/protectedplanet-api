require 'test_helper'

class WebPagesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.parse_file(File.expand_path('../../config.ru', __dir__))
  end

  def test_documentation_page_renders
    get '/documentation'

    assert last_response.ok?
    assert_includes last_response.body, 'API Documentation'
    refute_includes last_response.body, 'jquery-1.12.0.min.js'
  end

  def test_v3_documentation_page_renders
    get '/documentation/v3'

    assert last_response.ok?
    assert_includes last_response.body, 'V3 API Documentation (Archived)'
  end

  def test_web_response_includes_security_headers
    get '/documentation'

    assert_equal 'DENY', last_response.headers['X-Frame-Options']
    assert_equal 'nosniff', last_response.headers['X-Content-Type-Options']
    assert_equal 'strict-origin-when-cross-origin', last_response.headers['Referrer-Policy']
    assert_includes last_response.headers['Content-Security-Policy'], "default-src 'self'"
  end

  def test_request_page_includes_js_hook_classes_for_license_flow
    get '/request'

    assert last_response.ok?
    assert_includes last_response.body, 'js-licence-select'
    assert_includes last_response.body, 'js-licence-input'
  end
end
