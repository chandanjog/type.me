uri = URI.parse(ENV["REDISTOGO_URL"])
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

if Rails.env == 'test'
  $redis.select(1) #Choose a different database, default is 0 for dev, prod etc
end