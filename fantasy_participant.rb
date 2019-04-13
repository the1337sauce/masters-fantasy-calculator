class FantasyParticipant

  attr_reader :golfer_names, :team_name
  attr_accessor :todays_score, :round1_score, :round2_score, :round3_score, :round4_score,
    :todays_top_golfers, :round1_top_golfers, :round2_top_golfers, :round3_top_golfers, :round4_top_golfers

  def initialize participant_row
    @team_name = participant_row[0]
    @golfer_names = calculate_golfer_names(participant_row)
  end

  def calculate_golfer_names participant_row
    names = participant_row[1..8].compact.map { |golfer_name| golfer_name.strip }
  end

  def thursdays_leaderboard_score
    todays_score
  end

  def fridays_leaderboard_score
    round1_score + todays_score
  end

  def saturdays_leaderboard_score
    round1_score + round2_score + todays_score
  end

  def sundays_leaderboard_score
    round1_score + round2_score + round3_score + todays_score
  end

  def to_s
    "Team name #{@team_name}-golfers: #{golfer_names}-#{@round1_score}-\n
    #{@round2_score}"
  end

end
