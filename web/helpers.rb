module Web
  module Helpers
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials == [ENV["ADMIN_USERNAME"], ENV["ADMIN_PASSWORD"]]
    end

    def create_api_user params
      ApiUser.create(
        email:      params["email"],
        full_name:  params["fullname"],
        company:    params["company"],
        reason:     params["reason"],
        active:     false,
        token:      ApiUser.new_token
      )
    end
  end
end
