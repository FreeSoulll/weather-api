require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '30m' do
  forecast_service = ForecastService.new
  forecast_service.historical
end
