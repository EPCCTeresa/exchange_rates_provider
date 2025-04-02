class CnbExchangeRateServiceError < StandardError; end

class CnbExchangeRateService

  def initialize(country = nil)
    @country = country
  end

  def call
    exchange_rates = fetch_and_cache_rates

    if @country
      if exchange_rates[@country]
        exchange_rates[@country]
      else
        raise CnbExchangeRateServiceError, "Country #{@country} not found. Available countries: #{exchange_rates.keys.join(', ')}"
      end
    else
      exchange_rates
    end
  end

  private

  def fetch_and_cache_rates
    client = Clients::CnbExchangeRates.new
    exchange_rates = client.fetch_exchange_rates

    exchange_rates
  end
end
