class GeolocationService
  attr_reader :address_query

  def initialize(address_query)
    @address_query = address_query
  end

  def self.call(...)
    self.new(...).call
  end

  def call
    results = Geocoder.search(address_query)
    return if results.blank?

    results.first.coordinates
  end
end