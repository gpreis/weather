class WeatherForecastService
  def self.call(...)
    new.call(...)
  end

  def call(geolocation, days: 6)
    return if geolocation.blank? || geolocation.coordinates.blank?

    lat, lng = geolocation.coordinates
    zip_code = geolocation.postal_code

    response, cache_hit = cache_wrapper(zip_code) do
      forecast_request(lat, lng, days)
    end

    return unless response&.success?

    WeatherApi::ForecastResponse.from_response(response, cache_hit: cache_hit)
  end

  private

  def forecast_request(lat, lng, days)
    WeatherApi::Client.with_connection do |client|
      client.post("forecast.json") do |req|
        req.params[:q] = [lat, lng].join(",")
        req.params[:days] = days
      end
    end
  rescue Faraday::Error => e
    Rails.logger.error "Weather API request failed: #{e.message}"
    nil
  end

  def cache_wrapper(zip_code)
    return yield, false if zip_code.blank?

    cache_key = "forecast_#{zip_code}"
    cached_response = Rails.cache.read(cache_key)
    return cached_response, true if cached_response.present?

    fresh_response = yield
    Rails.cache.write(cache_key, fresh_response, expires_in: 30.minutes) if fresh_response&.success?

    [fresh_response, false]
  end
end
