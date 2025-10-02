class ForecastController < ApplicationController
  before_action :validate_address_param, only: [:search]

  def index; end

  def search
    geolocation = GeolocationService.call(address_param)

    handle_geolocation_error if geolocation && geolocation.postal_code.blank?

    @weather = WeatherForecastService.call(geolocation)

    return handle_weather_error if @weather.blank?
  end

  private

  def address_param
    params.require(:address).strip
  end

  def validate_address_param
    return if params[:address].present? && params[:address].strip.present?

    flash.now[:alert] = "Please enter a valid address."
    render :index and return
  end

  def handle_geolocation_error
    flash.now[:warning] = "Unable to determine a zip code for this address. Unable to use cache."
  end

  def handle_weather_error
    flash.now[:alert] = "Unable to fetch weather forecast. Please try again later."
    render :index
  end
end
