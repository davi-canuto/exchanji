require 'faraday'
require 'json'

class CurrencyConverter
  def self.call(from:, to:, amount:)
    raise ArgumentError, "Invalid amount" unless amount.is_a?(Numeric) && amount > 0
    raise ArgumentError, "Invalid currency code" unless from.is_a?(String) && to.is_a?(String)

    data, provider = processs_currency_conversion(from:, to:, amount:)

    {
      from: from,
      to: to,
      original_amount: amount,
      converted_amount: data["rates"][to],
      provider:
    }
  end

  def self.processs_currency_conversion(from:, to:, amount:)
    provider_response = nil
    provider          = nil

    provider_response, provider = try_frankfurter(from:, to:, amount:)
    provider_response, provider ||= try_exchange_rate(from:, to:, amount:)
    
    JSON.parse(provider_response.body), provider
  end

  def self.try_frankfurter(from:, to:, amount:)
    Faraday.get("https://api.frankfurter.app/latest") do |req|
      req.params['amount'] = amount
      req.params['from'] = from
      req.params['to'] = to
    end, 'frankfurter'
  end

  def self.try_exchange_rate(from:, to:, amount:)
    api_key = ENV.fetch('EXCHANGE_RATE_API_KEY', '')
    Faraday.get("https://v6.exchangerate-api.com/v6/#{api_key}/pair/#{from}/#{to}/#{amount.to_f}")
  end
end