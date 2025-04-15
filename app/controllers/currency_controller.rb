class CurrencyController
  def self.convert env
    request = Rack::Request.new(env)
    from = request.params['from']
    to = request.params['to']
    amount = request.params['amount'].to_f

    result = CurrencyConverter.call(from:, to:, amount:)

    [200, { 'Content-Type' => 'application/json' }, [result.to_json]]
  rescue => e
    [500, { 'Content-Type' => 'application/json' }, [{ error: e.message }.to_json]]
  end
end