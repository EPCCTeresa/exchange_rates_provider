class ExchangeRatesController < ApplicationController
    def index
      rates = Clients::CnbExchangeRates.new.fetch_exchange_rates
      render json: rates
    rescue => e
      render json: { error: e.message }, status: 500
    end
end
