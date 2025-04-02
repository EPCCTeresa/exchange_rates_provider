require 'rails_helper'

RSpec.describe ExchangeRatesController, type: :controller do
  describe 'GET #index' do
    let!(:all_rates) { { 'USA' => 23.127, 'EUR' => 24.955 } }
    context 'when a country is provided and available' do
      it 'returns the exchange rate for the given country' do
        allow(CnbExchangeRateService).to receive(:new).with('USA').and_return(double(call: { 'USA' => 23.127 }))

        get :index, params: { country: 'USA' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'USA' => 23.127 })
      end
    end

    context 'when a country is provided and not available' do
      let(:instance_double) { double('CnbExchangeRateService') }
      let(:error) { CnbExchangeRateServiceError.new("Country Mars not found. Available countries: USA, EUR") }
      it 'returns unprocessable_entity error' do
        allow(CnbExchangeRateService).to receive(:new).with('Mars').and_return(instance_double)
        allow(instance_double).to receive(:call).and_raise(error)

        get :index, params: { country: 'Mars' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Country Mars not found. Available countries: USA, EUR' })
      end
    end

    context 'when no country is provided' do
      it 'returns all exchange rates' do
        allow(CnbExchangeRateService).to receive(:new).and_return(double(call: all_rates))

        get :index

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(all_rates)
      end
    end
  end
end
