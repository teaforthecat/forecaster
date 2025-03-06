class ForecastsController < ApplicationController
  def new
    @address = Address.new
  end

  def show
    @address = Address.new(zipcode: params[:zipcode])
    if @address.valid?
      @cache_hit = true
      # 30 minute cache is a requirement, we rely on memcache to manage this
      @forecast = Rails.cache.fetch(@address.zipcode, expires_in: expires_in) do |_|
        @cache_hit = false # it is required to indicate cache hit or not
        request_forecast(@address)
      end
    else
      redirect_to new_forecast_url
    end
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

  def request_forecast(address)
    weather = WeatherApiService.new(address)
    time_steps = weather.forecast
    Forecast.new(address: address,
                 time_steps: time_steps,
                 cached_at: Time.now)
  end

  def address_params
    params.expect(address: [ :zipcode ])
  end

  def expires_in
    Rails.application
      .config.forecast_cache_minutes
      .minutes
  end
end
