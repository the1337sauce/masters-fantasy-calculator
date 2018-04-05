class FantasyParticipant

  attr_reader :golfer_names, :team_name
  attr_accessor :round1_score, :round2_score, :round3_score, :round4_score,
    :round1_top_golfers, :round2_top_golfers, :round3_top_golfers, :round4_top_golfers

  def initialize participant_row
    @team_name = participant_row[1]
    @golfer_names = calculate_golfer_names(participant_row)
  end

  def calculate_golfer_names participant_row
    names = participant_row[2..9].compact.map { |golfer_name| golfer_name.strip }
  end

  def overall_score_after_two_rounds
    round1_score + round2_score
  end

  def overall_score_after_three_rounds
    round1_score + round2_score + round3_score
  end

  def final_overall_score
    round1_score + round2_score + round3_score + round4_score
  end

  def to_s
    "Team name #{@team_name}-golfers: #{golfer_names}-#{@round1_score}-\n
    #{@round2_score}"
  end

end
