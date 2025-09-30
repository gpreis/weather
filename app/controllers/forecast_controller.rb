class ForecastController < ApplicationController
  def index; end

  def search
    postal_code = GeolocationService.new(params[:address]).call
    if postal_code.present?
      flash.now[:notice] = "Coordinates: #{postal_code}"
    else
      flash.now[:alert] = "Address not found!"
    end

    render :index
  end
end
