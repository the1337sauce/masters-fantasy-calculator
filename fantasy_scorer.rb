class FantasyScorer

    HOLE_TO_PAR = {1 => 4, 2 => 5, 3 => 4, 4 => 3, 5 => 4, 6 => 3, 7 => 4, 8 => 5, 9 => 4, 10 => 4,
      11 => 4, 12 => 3, 13 => 5, 14 => 4, 15 => 5, 16 => 3, 17 => 4, 18 => 4}

  def initialize fantasy_participants, golfer_results
    @fantasy_participants = fantasy_participants
    @golfer_results = golfer_results
  end

  def calculate_each_participants_rounds
    @fantasy_participants.each do |participant|
      participant.todays_score = calculate_todays_round_thus_far(participant.golfer_names)
      participant.round1_score = calculate_round(:r1, participant.golfer_names)
      participant.round2_score = calculate_round(:r2, participant.golfer_names)
      participant.round3_score = calculate_round(:r3, participant.golfer_names)
      participant.round4_score = calculate_round(:r4, participant.golfer_names)
      participant.todays_top_golfers = calculate_todays_round_top_golfers_thus_far(participant.golfer_names)
      participant.round1_top_golfers = top_golfers(:r1, participant.golfer_names)
      participant.round2_top_golfers = top_golfers(:r2, participant.golfer_names)
      participant.round3_top_golfers = top_golfers(:r3, participant.golfer_names)
      participant.round4_top_golfers = top_golfers(:r4, participant.golfer_names)
    end
  end

  private

  def calculate_round round, golfer_names
    total_score = top_golfers(round, golfer_names).map { |golfer_result| golfer_result.public_send(round).to_i }.reduce(:+)
    total_score - (72*6)
  end

  def calculate_todays_round_thus_far golfer_names
    calculate_todays_round_top_golfers_thus_far(golfer_names).map { |golfer_result| golfer_result.today.to_i }.reduce(:+)
  end

  def calculate_todays_round_top_golfers_thus_far golfer_names
    golfer_results(golfer_names).sort_by { |golfer| golfer.today.to_i }[0, 6]
  end

  def top_golfers round, golfer_names
    golfer_results(golfer_names).sort_by { |golfer_result| golfer_result.send(round).to_i }[0,6]
  end

  def golfer_results golfer_names
    golfer_names.map { |golfer_name| golfer_participants_hash[golfer_name] }
  end

  def golfer_participants_hash
    @golfer_results_hash ||= @golfer_results.each_with_object({}) { |player, hash| hash[player.name] = player }
  end

end
