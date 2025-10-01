class WeatherApiService
  include Singleton

  attr_reader :client

  def current(q)
    client.post('current.json') { |req| req.params[:q] = q }
  end

  def forecast(lat, lng, days: 3)
    response = client.post('forecast.json') do |req|
      req.params[:q] = [lat, lng].join(',')
    end

    WeatherApi::ForecastResponse.from_response(response) if response.success?
  end

  private

  def initialize
    # Keeping the API key here for simplicity, but it should be in environment variables and NEVER committed to github
    api_key = ENV.fetch("OPENWEATHER_API_KEY", "b80c2bdb4fcc4890929230834253009")
    base_url = 'http://api.weatherapi.com/v1'
    @client = Faraday.new(
      url: base_url,
      params: { key: api_key },
      headers: { 'Content-Type' => 'application/json' }
    ) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end
end
