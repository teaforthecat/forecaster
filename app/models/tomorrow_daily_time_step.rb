# Wrapper class around the timesteps from Tomorrow.io's forecast reponse
# see Docs: https://docs.tomorrow.io/reference/weather-forecast
# Note: Hourly and Minutely have different values than Daily(this)
class TomorrowDailyTimeStep
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :time, :datetime
  attribute :values


  def temperature
    values["temperatureAvg"]
  end

  def temperature_max
    values["temperatureMax"]
  end

  def temperature_min
    values["temperatureMin"]
  end
end
