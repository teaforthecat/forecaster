# README

Hello Reviewer!

I'm going to give this a narative style so it is easy to follow.

First, I'm going to setup the project by including the gems I like:
- rspec, factorybot: for tests
- httparty, vcr, webmock: for api testing 

The commands to setup the project:

``` shell
rails new forecast -T
cd forecast
bundle add rspec-rails factory_bot_rails 
bundle add httparty vcr webmock
rails g rspec:install
rails db:setup
```

Then I'll get a basic request test that submits the address and zipcode. 
Since the zipcode will be used for the cache key, I would try to negotiate with the project manager to have that be the only input for the first iteration. The address can be added next, and I will add that if I have time. 

Commands to get address submission test:

``` shell
rails g model Address zipcode
rails g controller Forecasts
```

A basic form submission is working. There is a bit of theory about why the controller name doesn't match the model name, but that may change. Basically, the controller represents the intention of the request and the model represents the data. The model is handling input validation, and the controller is handling routing, just as MVC intented. So, even though the names don't match, I still feel this is the Rails way. Another interesting bit is the zipcode as the param in the route. I think this makes sense as the zip is going to be the cache key and unique identifier for the Forecast.

Files added/edited:

``` shell
app/models/address.rb
app/controllers/forecasts_controller.rb
spec/requests/forecast_spec.rb
config/routes.rb
```

After doing a bit of research on Weather APIs, I see that Tomorrow.io offers a
Weather Forecast API that takes a zipcode. That sounds better than Weather.gov
which requires a lat,lng pair. So using Tomorrow.io would remove a Geolocation
API request. It is also free. I would write up an Architectural Decision
Record(ADR) for this decision, but this is good enough for now.

Next I will create a TomorrowAPI client with a unit test and a stored recording using VCR.













