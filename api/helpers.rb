module API
  module Helpers
    def authenticate!
      unless current_user
        Appsignal.increment_counter("unauthorized_access_count", 1)
        error!('Unauthorized. Invalid or expired token.', 401)
      end
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
      header 'description', 'API v3 is deprecated. Please migrate to v4. Visit the Protected Planet API website https://api.protectedplanet.net for v4 documentation.'
    end
  end
end
