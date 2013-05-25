class Race

  module Status
    AWAITING_PLAYERS = 0
    ACTIVE = 1
    COMPLETE = 2
  end

  attr_accessor :id, :status, :participants, :created_at, :winner, :text

  def initialize hash=nil
    if hash.nil?
      @id = get_id
      @status = Status::AWAITING_PLAYERS
      @participants = {}
      @created_at = DateTime.now
      @text = "Get well soon! ;:" #TODO: Fetch from an external api
    else
      @id = hash["id"]
      @status = hash["status"]
      @participants = hash["participants"]
      @created_at = hash["created_at"]
      @text = hash["text"]
    end
  end

  def add_participant user_id
    @participants[user_id] = { :progress => 0 }
  end


  private

  def get_id
    if $redis.get(Races::COUNTER).nil?
      $redis.set(Races::COUNTER,1)
      return "1";
    else
      $redis.incr(Races::COUNTER)
      $redis.get(Races::COUNTER)
    end
  end

end

