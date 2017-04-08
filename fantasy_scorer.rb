class FantasyScorer

    HOLE_TO_PAR = {1 => 4, 2 => 5, 3 => 4, 4 => 3, 5 => 4, 6 => 3, 7 => 4, 8 => 5, 9 => 4, 10 => 4,
      11 => 4, 12 => 3, 13 => 5, 14 => 4, 15 => 5, 16 => 3, 17 => 4, 18 => 4}

  def initialize fantasy_participants, golfer_results
    @fantasy_participants = fantasy_participants
    @golfer_results = golfer_results
  end

  def calculate_each_participants_rounds
    @fantasy_participants.each do |participant|
      participant.round1_score = calculate_round(:r1, participant.golfer_names)
      participant.round2_score = calculate_round(:r2, participant.golfer_names)
      participant.round1_top_golfers = top_golfers(:r1, participant.golfer_names)
      participant.round2_top_golfers = top_golfers(:r2, participant.golfer_names)
    end
  end

  private

  def calculate_round round, golfer_names
    this_participants_golfer_results = golfer_names.map { |golfer_name| golfer_participants_hash[golfer_name] }
    golfer_results_sorted = this_participants_golfer_results.sort_by { |golfer_result| golfer_result.send(round).to_i }[0,6]
    total_score = golfer_results_sorted.map { |golfer_result| golfer_result.public_send(round).to_i }.reduce(:+)
    total_score - (72*6)
  end

  def top_golfers round, golfer_names
    golfer_results = golfer_names.map { |golfer_name| golfer_participants_hash[golfer_name] }
    golfer_results_sorted = golfer_results.sort_by { |golfer_result| golfer_result.send(round) }[0,6]
  end

  def golfer_participants_hash
    @golfer_results_hash ||= @golfer_results.each_with_object({}) { |player, hash| hash[player.name] = player }
  end

end
