module API
  module Helpers
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
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
