module Web
  class Routes < Sinatra::Base
    get '/' do
      'Hello world.'
    end
  end
end
