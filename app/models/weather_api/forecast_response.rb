module WeatherApi
  class ForecastResponse
    attr_reader :location, :current, :forecast_days

    def initialize(location: {}, current: {}, forecast_days: [])
      @location = location
      @current = current
      @forecast_days = forecast_days
    end

    def self.from_response(response)
      body = JSON.parse(response.body, symbolize_names: true)

      forecast_current, *forecast_days = ForecastDay.many_from_hash(body.dig(:forecast, :forecastday))

      new(
        location: body[:location],
        current: Current.from_hash(**body[:current], forecast: forecast_current),
        forecast_days: forecast_days
      )
    end
  end
end