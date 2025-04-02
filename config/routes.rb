Rails.application.routes.draw do
  get "exchange_rates", to: "exchange_rates#index"
  get "exchange_rates/:country", to: "exchange_rates#index", country: /[a-zA-Z]{3}/
end
