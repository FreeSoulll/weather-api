require 'grape'

module Weather
  class Api < Grape::API
    format :json

    resource :weather do
      desc 'Get current temperature'
      get :current do
        temperature = Forecast.sorted.first.temperature
        { temperature: }
      end

      namespace :historical do
        desc 'Get hourly historical weather for last 24 hours'
        get :'/' do
          data = Forecast.historical.pluck(:temperature, :epoch_time)
          data.map do |temperature, epoch_time|
            { temperature:, epoch_time: }
          end
        end

        desc 'Get maximum temperature in the last 24 hours'
        get :max do
          max_temperature = Forecast.historical.maximum(:temperature)
          { temperature: max_temperature }
        end

        desc 'Get minimum temperature in the last 24 hours'
        get :min do
          min_temperature = Forecast.historical.minimum(:temperature)
          { temperature: min_temperature }
        end

        desc 'Get average temperature in the last 24 hours'
        get :avg do
          avg_temperature = Forecast.historical.average(:temperature).round(0)
          { temperature: avg_temperature }
        end
      end

      desc 'Get temperature closest to specified timestamp'
      params do
        requires :timestamp, type: Integer, desc: 'Timestamp in Unix format'
      end
      get :by_time do
        timestamp = params[:timestamp].to_i
        temperature = Forecast.by_time(timestamp)
        error!('Temperature not found for the given timestamp', 404) unless temperature
        { temperature: }
      end
    end

    resource :health do
      desc 'Health check endpoint'
      get do
        { status: 'OK' }
      end
    end
  end
end
