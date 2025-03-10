class WeatherApiService
  include HTTParty

  # API Docs: https://docs.tomorrow.io/reference/weather-forecast
  base_uri "https://api.tomorrow.io/v4/weather"

  attr_accessor :address

  # accepts Address
  # returns a list of TimeSteps
  def initialize(address)
    self.address = address
  end

  def forecast
    Rails.logger.info "WeatherAPIService requesting forecast"
    response = self.class.get("/forecast",
                   query: { location: location,
                            timesteps: timesteps,
                            apikey: apikey })
    render_timesteps response.parsed_response
  end

  private

  def render_timesteps(body)
    # Tommorow's api is flexible and will return strange things like bustops if
    # the zipcode is not a real, existing zipcode
    if body.dig("location", "type") != "postcode"
      raise InvalidRequest.new("zipcode not found: #{zipcode}")
    end
    body.dig("timelines", "daily").map { |step| TomorrowDailyTimeStep.new(step) }
  end

  # 1 day increments
  def timesteps
    "1d"
  end

  # Special format to tell Tomorrow.io that this is a zipcode and not a global
  # postal code. There are other options for this value, see doc link above.
  def location
    "#{zipcode} US"
  end

  def zipcode
    address.zipcode
  end

  # sticking with the smashcase apikey from Tomorrow.io for consistency
  def apikey
    Rails.application.credentials.tomorrow.apikey
  end

  class InvalidRequest < StandardError; end
end
