module WeatherApi
  class Condition
    attr_reader :text, :icon, :code

    def initialize(params = {})
      @text ||= params.fetch(:text)
      @icon ||= params.fetch(:icon)
      @code ||= params.fetch(:code)
    end
  end
end