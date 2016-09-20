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
  end
end
