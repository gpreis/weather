module WeatherApi
  class ForecastDay
    attr_reader :date, :maxtemp_c, :maxtemp_f, :mintemp_c, :mintemp_f, :condition

    delegate :text, :icon, :code, to: :condition, prefix: true

    def initialize(date:, maxtemp_c:, maxtemp_f:, mintemp_c:, mintemp_f:, condition:)
      @date = date
      @maxtemp_c = maxtemp_c
      @maxtemp_f = maxtemp_f
      @mintemp_c = mintemp_c
      @mintemp_f = mintemp_f
      @condition = condition
    end

    def self.from_hash(params = {})
      new(
        date: params[:date],
        maxtemp_c: params.dig(:day, :maxtemp_c),
        maxtemp_f: params.dig(:day, :maxtemp_f),
        mintemp_c: params.dig(:day, :mintemp_c),
        mintemp_f: params.dig(:day, :mintemp_f),
        condition: Condition.from_hash(params.dig(:day, :condition))
      )
    end

    def self.many_from_hash(forecastdays)
      forecastdays.map { |forecast| from_hash(forecast) }
    end
  end
end
