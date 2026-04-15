module Web
  module Helpers
    MARKDOWN_CACHE = {}
    MARKDOWN_CACHE_LOCK = Mutex.new

    def protected!
      return if authorized?

      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials == [ENV['ADMIN_USERNAME'], ENV['ADMIN_PASSWORD']]
    end

    def create_api_user(params)
      ApiUser.create(
        email: params['email'],
        full_name: params['fullname'],
        company: params['company'],
        reason: params['reason'],
        licence_number: params['licence_number'],
        has_licence: params['has_licence'],
        kind: params['kind'],
        active: false,
        token: ApiUser.new_token
      )
    end

    def markdown_cached(template_sym)
      template_path = File.join(settings.views, "#{template_sym}.md")
      return markdown(template_sym) unless File.file?(template_path)

      mtime = File.mtime(template_path).to_i
      cache_key = "#{template_sym}:#{mtime}"

      MARKDOWN_CACHE_LOCK.synchronize do
        MARKDOWN_CACHE[cache_key] ||= markdown(template_sym)
      end
    end
  end
end
