# frozen_string_literal: true

# Standalone load (no test_helper) — avoids DB boot for pure unit tests.
require 'minitest/autorun'
require_relative '../../api/auth_token'

class API::AuthTokenTest < Minitest::Test
  def test_parse_authorization_header_returns_nil_for_nil_or_blank
    assert_nil API::AuthToken.parse_authorization_header(nil)
    assert_nil API::AuthToken.parse_authorization_header('')
    assert_nil API::AuthToken.parse_authorization_header("  \t\n")
  end

  def test_parse_authorization_header_extracts_bearer_token_case_insensitive
    assert_equal 'abc123', API::AuthToken.parse_authorization_header('Bearer abc123')
    assert_equal 'abc123', API::AuthToken.parse_authorization_header('bearer abc123')
    assert_equal 'abc123', API::AuthToken.parse_authorization_header('BEARER abc123')
  end

  def test_parse_authorization_header_allows_whitespace_after_bearer_keyword
    assert_equal 'tok', API::AuthToken.parse_authorization_header("Bearer\ttok")
    assert_equal 'tok', API::AuthToken.parse_authorization_header("Bearer   tok")
  end

  def test_parse_authorization_header_returns_nil_for_non_bearer_or_malformed
    assert_nil API::AuthToken.parse_authorization_header('Token abc')
    assert_nil API::AuthToken.parse_authorization_header('Bearer')
    assert_nil API::AuthToken.parse_authorization_header('Bearer ')
    assert_nil API::AuthToken.parse_authorization_header('Bearer a b')
  end

  def test_token_provided_via_params_true_when_token_key_present
    assert API::AuthToken.token_provided_via_params?('token' => 'x')
    assert API::AuthToken.token_provided_via_params?(token: 'x')
  end

  def test_token_provided_via_params_false_when_missing_or_blank
    refute API::AuthToken.token_provided_via_params?({})
    refute API::AuthToken.token_provided_via_params?('token' => '')
    refute API::AuthToken.token_provided_via_params?(token: nil)
  end

  def test_from_grape_params_and_headers_prefers_query_token_over_authorization_header
    params = { 'token' => 'from-query' }
    headers = { 'Authorization' => 'Bearer from-header' }

    assert_equal 'from-query', API::AuthToken.from_grape_params_and_headers(params, headers)
  end

  def test_from_grape_params_and_headers_falls_back_to_bearer_when_no_param_token
    params = {}
    headers = { 'Authorization' => 'Bearer header-token' }

    assert_equal 'header-token', API::AuthToken.from_grape_params_and_headers(params, headers)
  end

  def test_from_rack_params_and_env_matches_grape_behaviour
    params = { 'token' => 'q' }
    env = { 'HTTP_AUTHORIZATION' => 'Bearer h' }

    assert_equal 'q', API::AuthToken.from_rack_params_and_env(params, env)
  end
end
