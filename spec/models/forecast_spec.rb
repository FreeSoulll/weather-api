require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe '.by_time' do
    let!(:forecast1) { create(:forecast, epoch_time: Time.now, temperature: 25) }
    let!(:forecast2) { create(:forecast, epoch_time: Time.now - 29.minutes, temperature: 30) }
    let!(:forecast3) { create(:forecast, epoch_time: Time.now - 31.minutes, temperature: 20) }

    context 'when a forecast exists within 30 minutes of the given timestamp' do
      it 'returns the temperature of the closest forecast' do
        timestamp = forecast1.epoch_time.to_i + 15.minutes.to_i
        expect(Forecast.by_time(timestamp)).to eq(25)

        timestamp = forecast2.epoch_time.to_i - 15.minutes.to_i
        expect(Forecast.by_time(timestamp)).to eq(30)
      end
    end

    context 'when no forecast exists within 30 minutes of the given timestamp' do
      it 'returns nil' do
        timestamp = forecast3.epoch_time.to_i - 35.minutes.to_i
        expect(Forecast.by_time(timestamp)).to be_nil
      end
    end
  end
end
