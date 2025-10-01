class WeatherService
  include Singleton

  attr_reader :client, :api_key, :base_url

  def current(q)
    client.post('current.json') { |req| req.params[:q] = q }
  end

  def forecast(lat, lng)
    client.post('forecast.json') { |req| req.params[:q] = [lat, lng].join(',')] }
  end

  private

  def initialize
    @api_key = ENV.fetch("OPENWEATHER_API_KEY", "b80c2bdb4fcc4890929230834253009")
    @base_url = 'http://api.weatherapi.com/v1'
    @client = Faraday.new(
      url: @base_url,
      params: {key: @api_key},
      headers: {'Content-Type' => 'application/json'}
    ) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end
end
