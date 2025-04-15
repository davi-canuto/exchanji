class CurrencyConverter
  include HTTParty
  base_uri 'https://api.exchangerate.host'

  def self.call(from:, to:, amount:)
    res = get("/convert", query: { from:, to:, amount: })
    data = res.parsed_response

    {
      from:,
      to:,
      original_amount: amount,
      converted_amount: data["result"],
      rate: data["info"]["rate"],
      provider: "exchangerate.host"
    }
  end
end