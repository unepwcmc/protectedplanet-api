module Web
  class Routes < Sinatra::Base
    get '/' do
      erb :home, layout: :layout
    end

    get '/request' do
      erb :request, layout: :layout
    end

    post '/request' do
      if @new_user = create_api_user(params)
        erb :request_success, layout: :layout
      else
        erb :request_error, layout: :layout
      end
    end

    def create_api_user params
      ApiUser.create(
        email:      params['email'],
        full_name:  params['fullname'],
        company:    params['company'],
        reason:     params['reason'],
        active:     false
      )
    end
  end
end
