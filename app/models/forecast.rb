class Forecast < ApplicationRecord
  scope :sorted, -> { order(epoch_time: :desc) }
  scope :historical, -> { sorted.limit(24) }

  def self.by_time(timestamp)
    all_forecasts = Forecast.pluck(:epoch_time, :temperature)

    forecast = all_forecasts.find do |epoch_time, _|
      (epoch_time.to_i - timestamp.to_i).abs <= 30.minutes.to_i
    end

    # возвращаем температуру
    forecast[1] if forecast
  end
end
