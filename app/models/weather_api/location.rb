module WeatherApi
  class Location
    attr_reader :name, :region, :country, :tz_id, :localtime

    def initialize(name:, region:, country:, tz_id:, localtime:)
      @name = name
      @region = region
      @country = country
      @tz_id = tz_id
      @localtime = localtime
    end

    def self.from_hash(hash)
      new(
        name: hash[:name],
        region: hash[:region],
        country: hash[:country],
        tz_id: hash[:tz_id],
        localtime: hash[:localtime]
      )
    end

    def full_name
      [name, region, country].reject(&:blank?).join(", ")
    end
  end
end