# Wrapper class around the timesteps from Tomorrow.io's forecast reponse
# see Docs: https://docs.tomorrow.io/reference/weather-forecast
class TomorrowDailyTimeStep
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :time, :date
  attribute :values


  def temperature
    values["temperatureAvg"]
  end
end
