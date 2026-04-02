module API
  module Helpers
    DEFAULT_PER_PAGE = 25

    def authenticate!
      return if current_user

      Appsignal.increment_counter('unauthorized_access_count', 1)
      error!('Unauthorized. Invalid or expired token.', 401)
    end

    def current_user
      user = ApiUser.where(token: params[:token], active: true).first
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
  end
end
