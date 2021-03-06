require 'csv'
require 'rest-client'
require 'json'
require './golfer_result.rb'
require './fantasy_scorer.rb'
require './fantasy_participant.rb'



def calculate_ranks_response
	participants = calculate_scores_for_participants
	response = []

	current_rank = 1
	last_score = -99999
	iterations = 1

	participants.each do |participant|
		saturdays_leaderboard_score = participant.saturdays_leaderboard_score
		if saturdays_leaderboard_score > last_score
			current_rank = iterations
			last_score = saturdays_leaderboard_score
		end
		response << {
								team_name: participant.team_name,
								through_third_round: saturdays_leaderboard_score,
								rank: current_rank
							}
		iterations = iterations + 1
	end
	response
end

private

def calculate_scores_for_participants
	parsed_golfer_result_response = JSON.parse(RestClient.get 'http://samsandberg.com/themasters/', {accept: :json, user_agent: 'linsna01'})['players']
	golfer_results = parsed_golfer_result_response.map { |player| GolferResult.new(player) }
	
	fantasy_picks = CSV.read('2019_picks.csv')
	fantasy_picks.shift

	fantasy_participants = fantasy_picks.map { |participant_row| FantasyParticipant.new(participant_row) }
	scorer = FantasyScorer.new(fantasy_participants, golfer_results)
	scorer.calculate_each_participants_rounds

	fantasy_participants.sort_by { |participant| participant.saturdays_leaderboard_score }
end
