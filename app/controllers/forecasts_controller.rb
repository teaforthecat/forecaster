class ForecastsController < ApplicationController
  def new
    @address = Address.new
  end

  def show
    # TODO: implement forecast
  end

  def create
    @address = Address.new address_params
    if @address.valid?
       redirect_to forecast_url(@address)
    else
       render :new
    end
  end

  private

  def address_params
    params.expect(address: [ :zipcode ])
  end
end
