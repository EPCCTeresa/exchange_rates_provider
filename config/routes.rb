Rails.application.routes.draw do
  get "exchange_rates", to: "exchange_rates#index"
  get "/exchange_rates/:country", to: "exchange_rates#index", constraints: { country: /[a-zA-Z0-9_]+/i }
end
