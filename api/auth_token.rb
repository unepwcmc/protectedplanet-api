# frozen_string_literal: true

module API
  module AuthToken
    class << self
      def from_rack_params_and_env(params, env)
        token_from_params_or_authorization(params, env['HTTP_AUTHORIZATION'])
      end

      def from_grape_params_and_headers(params, headers)
        token_from_params_or_authorization(params, headers['Authorization'])
      end

      def token_provided_via_params?(params)
        token = params['token'] || params[:token]
        !token.to_s.empty?
      end

      def parse_authorization_header(header)
        return nil unless header

        stripped = header.strip
        return nil if stripped.empty?

        match = stripped.match(/\ABearer\s+(\S+)\z/i)
        match&.captures&.first
      end

      private

      def token_from_params_or_authorization(params, authorization_header)
        token = params['token'] || params[:token]
        token = token.to_s
        return token unless token.empty?

        parse_authorization_header(authorization_header)
      end
    end
  end
end
