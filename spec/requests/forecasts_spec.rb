require 'rails_helper'

RSpec.describe Weather::Api, type: :request do
  include Rack::Test::Methods

  def app
    Weather::Api
  end

  let!(:forecast) { create(:forecast) }
  let!(:forecast_two) { create(:forecast, epoch_time: 'Sat, 11 Aug 2024 17:23:00.000000000 UTC +00:00', temperature: 20) }

  shared_examples 'a successful request' do |path, status, key, value|
    it "returns a successful response with #{key} of #{value}" do
      get(path)
      json_response = JSON.parse(last_response.body)

      expect(last_response.status).to eq(status)
      expect(json_response).to have_key(key)
      expect(json_response[key]).to eq(value)
    end
  end

  describe 'GET /weather/current' do
    include_examples 'a successful request', '/weather/current', 200, 'temperature', 28.0
  end

  describe 'GET /weather/historical/max' do
    include_examples 'a successful request', '/weather/historical/max', 200, 'temperature', 28.0
  end

  describe 'GET /weather/historical/min' do
    include_examples 'a successful request', '/weather/historical/min', 200, 'temperature', 20.0
  end

  describe 'GET /weather/historical/avg' do
    include_examples 'a successful request', '/weather/historical/avg', 200, 'temperature', 24.0
  end

  describe 'GET /health' do
    it 'returns ok' do
      get('/health')

      expect(last_response.status).to eq(200)
    end
  end

  describe 'GET /weather/by_time' do
    context 'when find closest timestamp' do
      it 'returns closest temperature' do
        get("/weather/by_time?timestamp=#{forecast.epoch_time.to_i + 29.minutes.to_i}")
        json_response = JSON.parse(last_response.body)

        expect(last_response.status).to eq(200)
        expect(json_response).to have_key('temperature')
        expect(json_response['temperature']).to eq(28.0)
      end
    end

    context 'when cannot find closest timestamp' do
      it 'returns error' do
        get("/weather/by_time?timestamp=#{forecast.epoch_time.to_i + 31.minutes.to_i}")
        json_response = JSON.parse(last_response.body)

        expect(last_response.status).to eq(404)
        expect(json_response['error']).to eq('Temperature not found for the given timestamp')
      end
    end
  end
end
