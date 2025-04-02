class ExchangeRatesController < ApplicationController
  def index
    country = params[:country]
    service = CnbExchangeRateService.new(country)

    begin
      @exchange_rate = service.call
      render json: @exchange_rate
    rescue CnbExchangeRateServiceError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
