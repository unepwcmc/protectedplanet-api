require 'test_helper'

class WebAdminTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.parse_file(File.expand_path('../../config.ru', __dir__))
  end

  def setup
    super
    @original_admin_username = ENV['ADMIN_USERNAME']
    @original_admin_password = ENV['ADMIN_PASSWORD']
    ENV['ADMIN_USERNAME'] = 'admin'
    ENV['ADMIN_PASSWORD'] = 'password'
  end

  def teardown
    ENV['ADMIN_USERNAME'] = @original_admin_username
    ENV['ADMIN_PASSWORD'] = @original_admin_password
    super
  end

  def test_get_admin_requires_basic_auth
    get '/admin'

    assert_equal 401, last_response.status
    assert_equal 'Basic realm="Restricted Area"', last_response.headers['WWW-Authenticate']
  end

  def test_get_admin_export_requires_basic_auth
    get '/admin/export'

    assert_equal 401, last_response.status
    assert_equal 'Basic realm="Restricted Area"', last_response.headers['WWW-Authenticate']
  end

  def test_get_admin_with_basic_auth_renders_active_users
    create(:api_user, email: 'active@example.com', active: true, archived: false)
    create(:api_user, email: 'archived@example.com', active: false, archived: true)

    authorize 'admin', 'password'
    get '/admin'

    assert last_response.ok?
    assert_includes last_response.body, 'Active Users'
    assert_includes last_response.body, 'active@example.com'
    refute_includes last_response.body, 'archived@example.com'
  end

  def test_get_admin_archived_only_lists_archived_users
    create(:api_user, email: 'active@example.com', active: true, archived: false)
    create(:api_user, email: 'archived@example.com', active: false, archived: true)

    authorize 'admin', 'password'
    get '/admin/archived'

    assert last_response.ok?
    assert_includes last_response.body, 'archived@example.com'
    refute_includes last_response.body, 'active@example.com'
  end
end
