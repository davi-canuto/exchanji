require_relative 'services/currency_converter_service'
require 'sinatra'
require 'json'

post '/convert' do
  content_type :json
  payload = JSON.parse(request.body.read)

  response = CurrencyConverter.call(
    from: payload['from'],
    to: payload['to'],
    amount: payload['amount']
  )

  { status: 200, record: response }.to_json
rescue StandardError => e
  { status: 422, record: nil }.to_json
end