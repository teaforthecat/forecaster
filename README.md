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

New files added:

``` shell
app/services/weather_api_service.rb
spec/services/weather_api_service_spec.rb
app/models/time_step.rb
```

Some notes on the above: The TomorrowDailyTimeStep class is a data model and serializer using
ActiveModel. It is meant to wrap the incoming data. If this class is serialized
in a cache it would hold all the data, even though we are using only a few
fields. I'm going to punt on removing the unused fields for now. I think this is
a good example of class design and encapsulation. The WeatherApiService is
another example of this. It has an exposed interface that could, in theory,
facilitate a different weather api in the future.

Next, I'll add the caching layer. The cache will expire based on time, which is
both part of the requirements and reasonable for the time-based domain of the
weather. Memcached is a good choice for this because of it's fifo time-based
expiration. Rails cache store supports Memcached, but it is't required locally,
just for production. I'll change the `config/environments/production.rb` file to
have `:mem_cache_store` and development and test to have `:memory_cache_store.
If this gets deployed, I'll add memcached host configuration at that time.
   
















