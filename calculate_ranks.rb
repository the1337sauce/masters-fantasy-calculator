require 'csv'
require 'rest-client'
require 'json'
require './golfer_result.rb'
require './fantasy_scorer.rb'
require './fantasy_participant.rb'



def calculate_ranks_response
	participants = calculate_scores_for_participants
	response = []
	participants.each do |participant|
		response << {
								team_name: participant.team_name,
								through_third_round: participant.overall_score_after_three_rounds
							}
	end
	response
end

private

def calculate_scores_for_participants
	parsed_golfer_result_response = JSON.parse(RestClient.get 'http://samsandberg.com/themasters/', {accept: :json})['players']
	golfer_results = parsed_golfer_result_response.map { |player| GolferResult.new(player) }

	fantasy_picks = CSV.read('picks.csv')
	fantasy_picks.shift
	fantasy_participants = fantasy_picks.map { |participant_row| FantasyParticipant.new(participant_row) }

	scorer = FantasyScorer.new(fantasy_participants, golfer_results)
	scorer.calculate_each_participants_rounds

	fantasy_participants.sort_by { |participant| participant.overall_score_after_three_rounds }
end
