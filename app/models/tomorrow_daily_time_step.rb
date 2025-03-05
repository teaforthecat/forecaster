# Wrapper class around the timesteps from Tomorrow.io's forecast reponse
# see Docs: https://docs.tomorrow.io/reference/weather-forecast
class TomorrowDailyTimeStep
  include ActiveModel::API
  attr_accessor :time, :values


  def temperature
    values["temperatureAvg"]
  end
end
