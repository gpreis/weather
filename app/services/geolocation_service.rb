class GeolocationService
  attr_reader :address_query

  def initialize(address_query)
    @address_query = address_query
  end

  def self.call(...)
    new(...).call
  end

  def call
    return if address_query.blank?

    results = Geocoder.search(address_query)
    return if results.blank?

    results.first
  end
end
