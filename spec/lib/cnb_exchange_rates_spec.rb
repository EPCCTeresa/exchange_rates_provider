require 'rails_helper'
require 'net/http'

RSpec.describe Clients::CnbExchangeRates, type: :client do
  describe '#fetch_exchange_rates' do
    let(:client) { Clients::CnbExchangeRates.new }

    context 'when the response is successful' do
      let(:response_body) do
        "Country|Code|Unit|Rate|Price\n" \
        "USA|USD|1|1.0|23.127\n" \
        "EUR|EUR|1|1.0|24.955\n" \
        "Australia|AUD|1|1.0|14.583\n" \
        "Brazil|BRL|1|1.0|4.006\n" \
        "Canada|CAD|1|1.0|16.17\n"
      end

      before do
        # Mocking Net::HTTP.get_response method
        uri = URI.parse('https://api.example.com/exchange_rates')
        response = instance_double(Net::HTTPResponse, body: response_body, is_a?: true)
        allow(response).to receive(:code).and_return("200")  # Set HTTP code to 200 (success)
        allow(Net::HTTP).to receive(:get_response).and_return(response)
      end

      it 'fetches and parses the exchange rates correctly' do
        result = client.fetch_exchange_rates

        expect(result).to be_a(Hash)
        expect(result).to include("USA" => 23.127)
        expect(result["USA"]).to eq(23.127)
        expect(result["EUR"]).to eq(24.955)
      end
    end

    context 'when the response has an error' do
      before do
        # Simulating a network error by raising an error
        allow(Net::HTTP).to receive(:get_response).and_raise(StandardError.new("Network error"))
      end

      it 'raises an error with the appropriate message' do
        expect { client.fetch_exchange_rates }
          .to raise_error(CnbExchangeRateError, "Unexpected error: Network error")
      end
    end

    context 'when the response is not successful' do
      let(:client) { Clients::CnbExchangeRates.new }

      before do
        uri = URI.parse(Clients::CnbExchangeRates::API_URL)
        response = instance_double(Net::HTTPResponse, body: "Error message", code: "500", message: "Error message", is_a?: false)
        allow(Net::HTTP).to receive(:get_response).with(uri).and_return(response)
      end

      it 'raises an error with the appropriate message' do
        expect { client.fetch_exchange_rates }
          .to raise_error(CnbExchangeRateError, "Error fetching exchange rates from CNB: Error message")
      end
    end

    context 'when the response format is invalid or incomplete' do
      let(:invalid_response_body) do
        "Invalid|Data|Here\n" \
        "Some|Bad|Line|Format\n"
      end

      before do
        uri = URI.parse('https://api.example.com/exchange_rates')
        response = instance_double(Net::HTTPResponse, body: invalid_response_body, is_a?: true)
        allow(response).to receive(:code).and_return("200")
        allow(Net::HTTP).to receive(:get_response).and_return(response)
      end

      it 'returns an empty hash when the response is invalid' do
        result = client.fetch_exchange_rates
        expect(result).to eq({})
      end
    end
  end
end
