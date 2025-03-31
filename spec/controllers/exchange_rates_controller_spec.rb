require 'rails_helper'

RSpec.describe ExchangeRatesController, type: :controller do
  describe "GET #index" do
    context "when the request is successful" do
      before do
        allow_any_instance_of(Clients::CnbExchangeRates).to receive(:fetch_exchange_rates).and_return(
          "USD" => 23.5, "EUR" => 26.5
        )

        get :index
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns exchange rates in JSON format" do
        json_response = JSON.parse(response.body)
        expect(json_response).to be_a(Hash)
        expect(json_response["USD"]).to eq(23.5)
        expect(json_response["EUR"]).to eq(26.5)
      end
    end

    context "when the request fails" do
      before do
        allow_any_instance_of(Clients::CnbExchangeRates)
        .to receive(:fetch_exchange_rates)
        .and_raise("Error fetching exchange rates from CNB")

        get :index
      end

      it "returns a 500 error response" do
        expect(response).to have_http_status(:internal_server_error)
      end

      it "returns an error message in JSON format" do
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Error fetching exchange rates from CNB")
      end
    end
  end
end
