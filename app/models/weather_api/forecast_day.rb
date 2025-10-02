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
      day_data = params[:day] || {}
      condition_data = day_data[:condition]

      new(
        date: params[:date],
        maxtemp_c: day_data[:maxtemp_c],
        maxtemp_f: day_data[:maxtemp_f],
        mintemp_c: day_data[:mintemp_c],
        mintemp_f: day_data[:mintemp_f],
        condition: condition_data && Condition.from_hash(condition_data)
      )
    end

    def self.many_from_hash(forecastdays)
      return [] if forecastdays.blank?

      forecastdays.map { |forecast| from_hash(forecast) }
    end
  end
end
