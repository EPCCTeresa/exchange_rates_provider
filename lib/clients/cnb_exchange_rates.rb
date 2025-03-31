class CnbExchangeRateError < StandardError
  def initialize(msg = "Error fetching exchange rates from CNB")
    super(msg)
  end
end

class Clients::CnbExchangeRates
  API_URL = "https://www.cnb.cz/en/financial_markets/foreign_exchange_market/exchange_rate_fixing/daily.txt"

  def fetch_exchange_rates
    uri = URI.parse(API_URL)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      parse_response(response.body)
    else
      raise CnbExchangeRateError, "Error fetching exchange rates from CNB: #{response.message}"
    end
  rescue CnbExchangeRateError => e
    raise e
  rescue StandardError => e
    raise CnbExchangeRateError, "Unexpected error: #{e.message}"
  end

  private

  def parse_response(response_body)
    rates = {}
    response_body.split("\n").each do |line|
      country, code, unit, rate, price = line.split("|")
      rates[country] = price.to_f if country && price
    end
    rates
  end
end
