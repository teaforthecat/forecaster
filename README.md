# README

## Setup to run locally

1. ensure ruby 3.2.2 is insalled
1. ensure bundler gem is installed
1. run `bundle` to install dependencies 
1. run `echo 'e25f0417fe1e7d33eaf8c98d6c4f96ba' > config/master.key` (we'll pretend this is coming from a secure system like a password manager)

That `master.key` will allow use of the encrypted credentials that contain the api key for Tomorrow.io

To run the service:
``` shell
bin/dev
```
Then visit `http://localhost:3000/` 

### Optional: run memcached locally 

To see the cache invalidation you'll need memcached running locally. You could
use brew or docker. You'll also have to wait 30 minutes or change the value in
ForcastsController. You'll also have to switch the setting in
`config/environments/development.md`; uncomment the line with `:mem_cache_store`. 

To use brew:

``` shell
brew install memcached
brew services start memcached
```

To use docker:

``` shell
 docker run -d --name my-memcached -p 11211:11211 memcached
```

Run the server with this:

``` shell
FORECAST_CACHE_MINUTES=1 bin/dev 
```


## Dev Notes

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

Then I'll get a basic request test that submits the address and zipcode. Since
the zipcode will be used for the cache key, I would try to negotiate with the
project manager to have that be the only input for the first iteration. The
address can be added next, and I will add that if I have time.

Commands to get address submission test:

``` shell
rails g model Address zipcode
rails g controller Forecasts
```
    
A basic form submission is working. There is a bit of theory I could share about
why the controller name doesn't match the model name. Basically, the controller
represents the intention of the request and the model represents the data. The
model is handling input validation, and the controller is handling routing, just
as MVC intented. So, even though the names don't match, I still feel this is the
Rails way. Another interesting bit is the zipcode as the param in the route. I
think this makes sense as the zip is going to be the cache key and unique
identifier for the Forecast.

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
app/models/tomorrow_daily_time_step.rb
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
weather. Memcached is a good choice for this because of its fifo time-based
expiration. Rails cache store supports Memcached, but it is't required locally,
just for production. I'll change the `config/environments/production.rb` file to
have `:mem_cache_store` and development and test to have `:memory_cache_store.
If this gets deployed, I'll add memcached host configuration at that time.
   

Note: I would like to clarify if zipcode is meant to mean US only. I have chosen
US only, but a global postal code would allow the app to serve the world as long
as the data set supports it. There would be two implications: our customers
would come to expect that level of service and we may not want to be tied to the
cost. We'd have to explore how to get reliable results from the
particular API I've selected, Tomorrow.io.


## Cleanup: 

I removed the migration that was generated as I decided not to use a database.
Accordingly, I changed the Address model to be a ActiveModel instead of
ActiveRecord. 

I added max/min to the page. This was trivial as the data was already there and it
demonstrates the application's strong design.

## Next steps:

I would add an address field to follow through on the original requirement of an
address search. This would either go straight to Tomorrow.io, which would return
the zipcode to be stored, or go to Google's Geolocation API to get a zipcode.
The input could be a loosely typed address search string and the zipcode could
even be a hidden field - in which case no change to the data flow would
be needed. 

The display could use some work. There could be icons and a pleasing reponsive
layout, but I opted for something that demostrates functionality.

The application could be deployed about anywhere. Heroku might be easiest, but I
also have a server at home that I could try to deploy it to. I'd just have to
setup a dynamic dns. 

Another thing would be to add a check on the value of the env var
FORECAST_CACHE_MINUTES because if that is flubbed `to_i` will return 0, and
cacheing will be accidentally disabled.

Lastly, removing the unused data from the response would be an easy way to
optimize the cache size needed.





