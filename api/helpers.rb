require 'api/auth_token'

module API
  module Helpers
    DEFAULT_PER_PAGE = 25

    def authenticate!
      return if current_user

      Appsignal.increment_counter('unauthorized_access_count', 1)
      error!('Unauthorized. Invalid or expired token.', 401)
    end

    def auth_token
      @auth_token ||= begin
        set_query_token_deprecation_headers if API::AuthToken.token_provided_via_params?(params)
        API::AuthToken.from_grape_params_and_headers(params, headers)
      end
    end

    def set_query_token_deprecation_headers
      header 'Deprecation', 'true'
      header 'Warning',
             '299 - "Passing token as a query or form parameter is deprecated and will not be supported in next major version; use Authorization: Bearer."'
    end

    def current_user
      user = ApiUser.where(token: auth_token, active: true).first
      if user&.active
        @current_user = user
      else
        false
      end
    end

    def set_v3_deprecation_headers
      header 'deprecated', 'true'
      header 'description',
             'API v3 is deprecated and will be removed on 1st/May/2026. Please migrate to v4. Visit the Protected Planet API website https://api.protectedplanet.net for v4 documentation.'
    end

    def paginate_collection(collection)
      page = params[:page].presence || 1
      per_page = params[:per_page].presence || DEFAULT_PER_PAGE

      collection.page(page).per(per_page)
    end

    def pagination_payload(paginated_collection)
      {
        'page' => paginated_collection.current_page,
        'per_page' => paginated_collection.limit_value,
        'total_pages' => paginated_collection.total_pages,
        'total_count' => paginated_collection.total_count
      }
    end
  end
end
