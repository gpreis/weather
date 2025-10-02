require "connection_pool"
require "faraday"
require "faraday/retry"

module WeatherApi
  class Client
    class << self
      def pool
        @pool ||= ConnectionPool.new(size: pool_size, timeout: 5) do
          create_client
        end
      end

      def with_connection(&block)
        pool.with(&block)
      end

      private

      def pool_size
        ENV.fetch("WEATHER_API_POOL_SIZE", "10").to_i
      end

      def create_client
        Faraday.new(
          url: "http://api.weatherapi.com/v1",
          params: { key: api_key },
          headers: { "Content-Type" => "application/json" }
        ) do |faraday|
          faraday.request :url_encoded
          faraday.request :retry, {
            max: 3,
            interval: 0.5,
            interval_randomness: 0.1,
            backoff_factor: 2,
            retry_statuses: [429, 500, 502, 503, 504],
            methods: [:get, :post]
          }
          faraday.response :logger if Rails.env.development?
          faraday.options.timeout = 10
          faraday.options.open_timeout = 5
          faraday.adapter Faraday.default_adapter
        end
      end

      def api_key
        # API KEY should never be hardcoded in a real project - but keep it here for simplicity sake
        # In a real world project, it should be in an environment variable and NEVER committed to any source control
        ENV.fetch("OPENWEATHER_API_KEY", "b80c2bdb4fcc4890929230834253009")
      end
    end
  end
end
