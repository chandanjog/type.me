$redis = Redis.new(:host => 'localhost', :port => 6379)
if Rails.env == 'test'
  $redis.select(1) #Choose a different database, default is 0 for dev, prod etc
end