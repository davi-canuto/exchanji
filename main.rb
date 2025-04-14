require_relative 'config/environment'

class ExchanjiApp < Sinatra::Base
  register Sinatra::Namespace
  register Sinatra::JSON

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get]
    end
  end

  namespace '/api' do
    get '/convert', &CurrencyController.method(:convert)
  end
end