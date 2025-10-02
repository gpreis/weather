class ForecastController < ApplicationController
  def index; end

  def search
    geolocation = GeolocationService.new(params[:address]).call
    postal_code = geolocation.postal_code

    if postal_code.blank?
      flash.now[:alert] = "Not able to determine a zip code for this address!"

      return render :index
    end

    @weather = WeatherApiService.instance.forecast(geolocation)
  end
end
