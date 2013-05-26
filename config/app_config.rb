require 'configatron'

configatron.race.max_participants = 10
configatron.race.available.to.join.for.in.seconds = 10

if Rails.env == 'test'
  configatron.race.max_participants = 2
  configatron.race.available.to.join.for.in.seconds = 1
end


if Rails.env == 'production'
  configatron.race.max_participants = 400
end

