module WeatherApi
  class ForecastResponse
    attr_reader :location, :current, :forecast_days, :cache_hit

    def initialize(location: {}, current: {}, forecast_days: [], cache_hit: false)
      @location = location
      @current = current
      @forecast_days = forecast_days
      @cache_hit = cache_hit
    end

    def self.from_response(response, cache_hit:)
      body = JSON.parse(response.body, symbolize_names: true)

      forecast_current, *forecast_days = ForecastDay.many_from_hash(body.dig(:forecast, :forecastday))

      new(
        location: Location.from_hash(body[:location]),
        current: Current.from_hash(**body[:current], forecast: forecast_current),
        forecast_days: forecast_days,
        cache_hit: cache_hit
      )
    end
  end
end
