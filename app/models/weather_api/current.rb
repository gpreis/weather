module WeatherApi
  class Current
    attr_reader :temp_c, :temp_f, :condition, :forecast

    delegate :text, :icon, :code, to: :condition, prefix: true, allow_nil: true
    delegate :maxtemp_c, :maxtemp_f, :mintemp_c, :mintemp_f, to: :forecast, allow_nil: true

    def initialize(temp_c:, temp_f:, condition:, forecast: nil)
      @temp_c = temp_c
      @temp_f = temp_f
      @condition = condition
      @forecast = forecast
    end

    def self.from_hash(params = {})
      new(
        temp_c: params[:temp_c],
        temp_f: params[:temp_f],
        condition: Condition.from_hash(params[:condition]),
        forecast: params[:forecast]
      )
    end
  end
end
