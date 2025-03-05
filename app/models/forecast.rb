class Forecast
  include ActiveModel::API

  attr_accessor :address, :cached_at, :time_steps, :cache_hit
end
