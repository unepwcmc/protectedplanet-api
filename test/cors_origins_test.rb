require 'minitest/autorun'
require_relative '../config/cors_origins'

class CorsOriginsTest < Minitest::Test
  def setup
    @saved_env = {
      'RACK_ENV' => ENV['RACK_ENV'],
      'CORS_ORIGINS' => ENV['CORS_ORIGINS']
    }
  end

  def teardown
    @saved_env.each { |k, v| v.nil? ? ENV.delete(k) : ENV[k] = v }
  end

  def test_allows_empty_cors_in_development
    ENV['RACK_ENV'] = 'development'
    ENV.delete('CORS_ORIGINS')

    CorsOrigins.ensure_explicit_origins!
  end

  def test_requires_non_empty_cors_in_production
    ENV['RACK_ENV'] = 'production'
    ENV['CORS_ORIGINS'] = '   '

    error = assert_raises(RuntimeError) { CorsOrigins.ensure_explicit_origins! }
    assert_includes error.message, 'CORS_ORIGINS must be set'
  end

  def test_allows_explicit_cors_in_staging
    ENV['RACK_ENV'] = 'staging'
    ENV['CORS_ORIGINS'] = 'https://example.com'

    CorsOrigins.ensure_explicit_origins!
  end
end
