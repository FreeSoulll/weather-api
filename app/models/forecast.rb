class Forecast < ApplicationRecord
  scope :sorted, -> { order(epoch_time: :desc) }
  scope :historical, -> { sorted.limit(24) }

  DEFAULT_TIME = 30.minutes.to_i

  def self.by_time(timestamp)
    start_time = Time.at(timestamp.to_i - 30.minutes.to_i)
    end_time = Time.at(timestamp.to_i + 30.minutes.to_i)

    Forecast.where(epoch_time: start_time..end_time).limit(1).pluck(:temperature).first
  end
end
