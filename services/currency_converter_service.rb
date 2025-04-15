require 'faraday'
require 'json'

class CurrencyConverter
   def self.call(from:, to:, amount:)
    response = Faraday.get("https://api.frankfurter.app/latest") do |req|
      req.params['amount'] = amount
      req.params['from'] = from
      req.params['to'] = to
    end

    data = JSON.parse(response.body)

    {
      from: from,
      to: to,
      original_amount: amount,
      converted_amount: data["rates"][to],
      provider: "frankfurter.app"
    }
  end
end