# config/routes.rb
Rails.application.routes.draw do
  get "/exchange_rates", to: "exchange_rates#index"
end
