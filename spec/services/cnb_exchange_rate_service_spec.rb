require 'rails_helper'

RSpec.describe CnbExchangeRateService, type: :service do
  describe '#call' do
    subject(:service) { described_class.new(country) }
    let!(:all_rates) { { 'USA' => 23.127, 'EUR' => 24.955, 'United Kingdom' => 29.89  } }

    context 'when a country is provided and valid' do
      let(:country) { 'USA' }
      it 'returns the exchange rate for the given country' do
        allow_any_instance_of(Clients::CnbExchangeRates).to receive(:fetch_exchange_rates).and_return(all_rates)

        result = service.call

        expect(result).to eq(23.127)
      end
    end

    context 'when a country is provided and invalid' do
      let(:country) { 'Mars' }

      it 'raises an error if the country is not found' do
        allow_any_instance_of(Clients::CnbExchangeRates).to receive(:fetch_exchange_rates).and_return(all_rates)

        expect { service.call }.to raise_error(CnbExchangeRateServiceError, "Country Mars not found. Available countries: USA, EUR, United Kingdom")
      end
    end

    context 'when the country name consists of two words' do
      let(:country) { 'united_kiNgdom' }
      it 'returns exchange rate for the country regardless of the case' do
        allow_any_instance_of(Clients::CnbExchangeRates).to receive(:fetch_exchange_rates).and_return(all_rates)
        result = service.call
        expect(result).to eq(29.89)
      end
    end

    context 'when no country is provided' do
      let(:country) { nil }

      it 'returns all exchange rates' do
        allow_any_instance_of(Clients::CnbExchangeRates).to receive(:fetch_exchange_rates).and_return(all_rates)

        result = service.call

        expect(result).to eq(all_rates)
      end
    end

    context 'when the rates are cached' do
      let(:country) { nil }
      it 'returns the cached exchange rates' do
        allow_any_instance_of(Clients::CnbExchangeRates).to receive(:fetch_exchange_rates).and_return(all_rates)
        result = service.call

        expect(result).to eq(all_rates)

        expect(Rails.cache.read(CnbExchangeRateService::CACHE_KEY)).to eq(all_rates)
      end
    end
  end
end
