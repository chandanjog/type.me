class Race

  module Status
    ACTIVE = "ACTIVE"
    COMPLETE = "COMPLETE"
  end

  attr_accessor :id, :status, :participants, :created_at, :winner, :text, :guest_counter

  def initialize hash={}
    @id = hash["id"].nil? ? get_id : hash["id"]
    @status = hash["status"].nil? ? Status::ACTIVE : hash["status"]
    @participants = hash["participants"].nil? ? {} : hash["participants"]
    @created_at = hash["created_at"].nil? ? DateTime.now : hash["created_at"]
    @text = hash["text"].nil? ? Quote.text : hash["text"] #TODO: Fetch from an external api
    @guest_counter = hash["guest_counter"].nil? ? 1 : hash["guest_counter"]
    @race_available_to_join_for_in_seconds = configatron.race.available.to.join.for.in.seconds.to_i
  end

  def add_participant(user_id)
    if user_id.blank?
      @participants["guest_#{@guest_counter}"] = {:progress => 0}
      @guest_counter=@guest_counter + 1
    else
      @participants[user_id] = {:progress => 0}
    end
  end

  def update_participant(user_id, progress)
    @participants[user_id] = {:progress => progress}
  end

  def available_to_join
    @participants.count < configatron.race.max_participants.to_i &&
        time_elapsed_since_creation_in_seconds < @race_available_to_join_for_in_seconds
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

