module WeatherApi
  class Current
    attr_reader :temp_c, :temp_f, :condition, :forecast

    delegate :text, :icon, :code, to: :condition, prefix: true, allow_nil: true
    delegate :maxtemp_c, :maxtemp_f, :mintemp_c, :mintemp_f, to: :forecast, allow_nil: true

    def initialize(params = {})
      @temp_c = params.fetch(:temp_c, 0.0)
      @temp_f = params.fetch(:temp_f, 0.0)
      @condition = params.fetch(:condition, nil)
      @forecast = params.fetch(:forecast, nil)
    end

    def self.from_hash(params = {})
      new(
        temp_c: params.fetch(:temp_c),
        temp_f: params.fetch(:temp_f),
        condition: Condition.new(params.fetch(:condition)),
        forecast: params.fetch(:forecast)
      )
    end
  end
end
