module WeatherApi
  class Condition
    attr_reader :text, :icon, :code

    def initialize(text:, icon:, code:)
      @text = text
      @icon = icon
      @code = code
    end

    def self.from_hash(hash)
      new(
        text: hash[:text],
        icon: hash[:icon],
        code: hash[:code]
      )
    end
  end
end
