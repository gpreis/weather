module WeatherApi
  class ForecastDay
    attr_reader :date, :maxtemp_c, :maxtemp_f, :mintemp_c, :mintemp_f, :condition

    delegate :text, :icon, :code, to: :condition, prefix: true

    def initialize(params = {})
      @date = params.fetch(:date)
      @maxtemp_c = params.fetch(:maxtemp_c)
      @maxtemp_f = params.fetch(:maxtemp_f)
      @mintemp_c = params.fetch(:mintemp_c)
      @mintemp_f = params.fetch(:mintemp_f)
      @condition = params.fetch(:condition)
    end

    def self.from_hash(params = {})
      new(
        date: params.fetch(:date),
        maxtemp_c: params.dig(:day, :maxtemp_c),
        maxtemp_f: params.dig(:day, :maxtemp_f),
        mintemp_c: params.dig(:day, :mintemp_c),
        mintemp_f: params.dig(:day, :mintemp_f),
        condition: Condition.new(params.dig(:day, :condition))
      )
    end

    def self.many_from_hash(forecastdays)
      forecastdays.collect { |forecast| from_hash(forecast) }
    end
  end
end
