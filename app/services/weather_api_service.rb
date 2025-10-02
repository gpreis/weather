class WeatherApiService
  include Singleton

  attr_reader :client

  def self.forecast(...)
    instance.forecast(...)
  end

  def forecast(geolocation, days: 6)
    lat, lng = geolocation.coordinates
    zip_code = geolocation.postal_code

    response, cache_hit = cache_wrapper("forecast_#{zip_code}") do
      client.post("forecast.json") do |req|
        req.params[:q] = [ lat, lng ].join(",")
        req.params[:days] = days
      end
    end

    WeatherApi::ForecastResponse.from_response(response, cache_hit: cache_hit) if response.success?
  end

  def cache_wrapper(cache_key)
    response = Rails.cache.read(cache_key)

    return response, true if response.present?

    response = yield

    Rails.cache.write(cache_key, response, expires_in: 30.minutes)
    return response, false
  end

  private

  def initialize
    # API KEY should never be hardcoded in a real project - but keep for simplicity sake
    # It should be in environment variables and NEVER committed to github
    api_key = ENV.fetch("OPENWEATHER_API_KEY", "b80c2bdb4fcc4890929230834253009")
    base_url = "http://api.weatherapi.com/v1"
    @client = Faraday.new(
      url: base_url,
      params: { key: api_key },
      headers: { "Content-Type" => "application/json" }
    ) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end
end
