require 'configatron'

configatron.race.max_participants = 2

if Rails.env == 'production'
  configatron.race.max_participants = 400
end

