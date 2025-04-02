class CnbExchangeRateServiceError < StandardError; end

class CnbExchangeRateService
  CACHE_KEY = "cnb_exchange_rates"

  def initialize(country = nil)
    @country = country
  end

  def call
    exchange_rates = Rails.cache.read(CACHE_KEY)

    if exchange_rates.nil?
      exchange_rates = fetch_and_cache_rates
    end

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

    Rails.cache.write(CACHE_KEY, exchange_rates, expires_in: 1.hour)
    exchange_rates
  end
end
