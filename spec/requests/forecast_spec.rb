require 'rails_helper'

RSpec.describe "Forecasts", type: :request do
  describe "GET /" do
    it "renders the form on the root path " do
      get new_forecast_path
      expect(response.body).to include("Submit")
    end

    it "accepts the submitted form" do
      post forecasts_path, params: { address: { zipcode: "12345" } }
      expect(response).to be_redirect
    end
  end
end
