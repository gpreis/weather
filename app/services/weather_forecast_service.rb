class WeatherForecastService
  include Singleton

  attr_reader :client

  def self.call(...)
    instance.call(...)
  end

  def call(geolocation, days: 6)
    lat, lng = geolocation.coordinates
    zip_code = geolocation.postal_code

    response, cache_hit = cache_wrapper("forecast_#{zip_code}") do
      make_api_request(lat, lng, days)
    end

    return unless response.success?

    WeatherApi::ForecastResponse.from_response(response, cache_hit: cache_hit)
  end

  private

  def make_api_request(lat, lng, days)
    client.post("forecast.json") do |req|
      req.params[:q] = [ lat, lng ].join(",")
      req.params[:days] = days
    end
  end

  def cache_wrapper(cache_key)
    cached_response = Rails.cache.read(cache_key)
    return cached_response, true if cached_response.present?

    fresh_response = yield
    Rails.cache.write(cache_key, fresh_response, expires_in: 30.minutes) if fresh_response&.success?

    [ fresh_response, false ]
  end

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
