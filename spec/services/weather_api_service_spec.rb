require 'rails_helper'

RSpec.describe WeatherApiService do
  around(:each) do |ex|
    VCR.insert_cassette(:tomorrow)
    ex.run
    VCR.eject_cassette(:tomorrow)
  end

  let(:valid_address) { build(:address) }

  it 'calls the forecast resource with a zipcode parameter' do
    weather = WeatherApiService.new(valid_address)
    result = weather.forecast
    expect(result.first.time).to eql("2025-03-05T11:00:00Z")
    expect(result.first.temperature).to eql(10.3)
  end

  let(:invalid_address) { build(:address, zipcode: "00000") }
  it 'raises an error if the zip does not exist' do
    weather = WeatherApiService.new(invalid_address)
    expect { weather.forecast }.to raise_error(WeatherApiService::InvalidRequest)
  end
end
