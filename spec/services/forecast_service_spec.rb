require 'rails_helper'
require 'vcr'

RSpec.describe ForecastService do
  describe '#historical' do
    let(:service) { described_class.new }

    before do
      allow(Forecast).to receive(:upsert_all)
    end

    context 'when the response is successful' do
      it 'parses the response and saves the data' do
        VCR.use_cassette('forecast/historical_success') do
          service.historical
        end

        expect(Forecast).to have_received(:upsert_all).with(
          array_including(
            hash_including(:epoch_time, :temperature, :created_at, :updated_at)
          ),
          unique_by: :epoch_time
        )
      end
    end
  end
end

# Настройки VCR
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock

  # Фильтруем чувствительные данные
  config.filter_sensitive_data('<API_KEY>') { ENV['API_KEY'] }
  config.filter_sensitive_data('<LOCATION_KEY>') { ENV['LOCATION_KEY'] }

  config.configure_rspec_metadata!
end
