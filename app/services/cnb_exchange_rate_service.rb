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
      country_normalized = normalize_country_name(@country)

      country_found = exchange_rates.keys.find do |key|
        normalize_country_name(key) == country_normalized
      end

      if country_found
        exchange_rates[country_found]
      else
        raise CnbExchangeRateServiceError, "Country #{@country} not found. Available countries: #{exchange_rates.keys.join(', ')}"
      end
    else
      exchange_rates
    end
  end

  private

  def normalize_country_name(name)
    name.downcase.tr("_", " ")
  end

  def fetch_and_cache_rates
    client = Clients::CnbExchangeRates.new
    exchange_rates = client.fetch_exchange_rates

    Rails.cache.write(CACHE_KEY, exchange_rates, expires_in: 1.hour)
    exchange_rates
  end
end
