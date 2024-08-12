class ForecastService
  BASE_URL = 'https://dataservice.accuweather.com'.freeze
  API_KEY = ENV['API_KEY'].freeze
  LOCATION_KEY = ENV['LOCATION_KEY'].freeze

  def historical
    response = client.get("currentconditions/v1/#{LOCATION_KEY}/historical/24")
    data = JSON.parse(response.body)

    save_data(data) if response.success?
  end

  private

  def client
    @client ||= Faraday.new(url: BASE_URL) do |conn|
      conn.request :url_encoded
      conn.params[:apikey] = API_KEY
    end
  end

  def save_data(resp)
    forecasts = resp.map do |data|
      {
        epoch_time: Time.at(data['EpochTime']),
        temperature: data['Temperature']['Metric']['Value'],
        created_at: Time.now,
        updated_at: Time.now
      }
    end

    puts forecasts

    Forecast.upsert_all(forecasts, unique_by: :epoch_time)
  end
end
