require 'ostruct'

class Races
  KEY = "races"
  COUNTER = "races.counter"

  class << self

    def add_or_update race
      existing_race = find_by_id(race.id)
      if existing_race.nil?
        $redis.sadd(KEY, race.to_json)
      else
        $redis.srem(KEY, existing_race.to_json)
        $redis.sadd(KEY, race.to_json)
      end
    end

    def find_by_id id
      all.find do |race|
        puts race.inspect
        race.id == id
      end
    end

    def find_available_race
      all.find do |race|
        #debugger
        race.status == Race::Status::AWAITING_PLAYERS && race.participants.count < configatron.race.max_participants.to_i
      end
    end

    private

    def all
      $redis.smembers(KEY).map do |race|
        Race.new(JSON.parse(race))
      end
    end


  end

end
