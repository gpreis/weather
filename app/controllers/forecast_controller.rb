class ForecastController < ApplicationController
  def index; end

  def search
    geolocation = GeolocationService.new(params[:address]).call
    postal_code = geolocation.postal_code

    if postal_code.present?
      flash.now[:notice] = "zipcode: #{postal_code}"
    else
      flash.now[:alert] = "Not able to determine a zip code for this address!"
    end

    @address = params[:address]
    @weather = WeatherApiService.instance.forecast(*geolocation.coordinates)
  end
end
