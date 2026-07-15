require 'test_helper'

class WebRequestsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.parse_file(File.expand_path('../../config.ru', __dir__))
  end

  def test_post_request_creates_api_user_and_renders_success
    token = csrf_token_for('/request')
    refute_nil token

    assert_difference('ApiUser.count', +1) do
      post '/request',
           {
             _csrf: token,
             email: 'new-user@example.com',
             fullname: 'New User',
             company: 'WCMC',
             reason: 'Testing request flow',
             kind: 'Education',
             has_licence: 'Yes',
             licence_number: 'LIC-123'
           }
    end

    assert last_response.ok?
    assert_includes last_response.body, 'Thank you for your request!'

    user = ApiUser.order(:id).last
    assert_equal 'new-user@example.com', user.email
    assert_equal 'New User', user.full_name
    assert_equal 'WCMC', user.company
    assert_equal 'Testing request flow', user.reason
    assert_equal 'Education', user.kind
    assert_equal 'Yes', user.has_licence
    assert_equal 'LIC-123', user.licence_number
    assert_equal false, user.active
  end

  def test_post_request_renders_error_template_when_creation_returns_nil
    token = csrf_token_for('/request')
    refute_nil token

    original_method = Web::Helpers.instance_method(:create_api_user)
    Web::Helpers.send(:define_method, :create_api_user) { |_params| nil }

    post '/request', { _csrf: token, email: 'broken@example.com' }
    assert last_response.ok?
    assert_includes last_response.body, 'We could not process your request.'
  ensure
    Web::Helpers.send(:define_method, :create_api_user, original_method)
  end

  private

  def csrf_token_for(path)
    get path
    last_response.body[/name="_csrf" value="([^"]+)"/, 1]
  end

  def assert_difference(expression, difference)
    before = eval(expression)
    yield
    after = eval(expression)
    assert_equal(before + difference, after)
  end
end
