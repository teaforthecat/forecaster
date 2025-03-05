require 'rails_helper'

RSpec.describe "Forecasts", type: :request do
  around(:each) do |ex|
    VCR.insert_cassette(:tomorrow)
    ex.run
    VCR.eject_cassette(:tomorrow)
  end

  describe "GET /" do
    it "renders the form on the root path " do
      get new_forecast_path
      expect(response.body).to include("Submit")
    end

    it "accepts the submitted form" do
      post forecasts_path, params: { address: { zipcode: "12345" } }
      expect(response).to be_redirect
    end

    let(:address) { build(:address) }
    it "indicates if the response is cached" do
      # first request is not a cache hit
      get forecast_path(address)
      expect(response.status).to eql(200)
      expect(response.body).to_not include("(cached)")

      # second request _is_ a cache hit
      get forecast_path(address)
      expect(response.body).to include("(cached)")
    end

    let(:invalid_address) { build(:address, zipcode: 'abcd1234') }
    it "should redirect to the new action" do
      get forecast_path(invalid_address)
      expect(response.status).to eql(302)
    end
  end
end
