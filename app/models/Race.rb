class Race

  module Status
    ACTIVE = 1
    COMPLETE = 2
  end

  attr_accessor :id, :status, :participants, :created_at, :winner, :text

  def initialize hash={}
    @id = hash["id"].nil? ? get_id : hash["id"]
    @status = hash["status"].nil? ? Status::ACTIVE : hash["status"]
    @participants = hash["participants"].nil? ? {} : hash["participants"]
    @created_at = hash["created_at"].nil? ? DateTime.now : hash["created_at"]
    @text = hash["text"].nil? ? Quote.text : hash["text"] #TODO: Fetch from an external api
  end

  def add_participant user_id
    @participants[user_id] = {:progress => 0}
  end

  def available_to_join
    @participants.count < configatron.race.max_participants.to_i &&
        time_elapsed_since_creation_in_seconds < configatron.race.available.to.join.for.in.seconds.to_i
  end

  def time_elapsed_since_creation_in_seconds
    time_difference = (DateTime.now - DateTime.parse(@created_at))
    Rails.logger.info "******** Time difference :: #{time_difference}"
    Rails.logger.info "******** Time difference in seconds :: #{(time_difference * 24 * 60 * 60).to_i}"
    (time_difference * 24 * 60 * 60).to_i
  end

  private

  def get_id
    if $redis.get(Races::COUNTER).nil?
      $redis.set(Races::COUNTER, 1)
      return "1";
    else
      $redis.incr(Races::COUNTER)
      $redis.get(Races::COUNTER)
    end
  end

end

