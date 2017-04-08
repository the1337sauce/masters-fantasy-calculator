require 'csv'
require 'rest-client'
require 'json'
require './golfer_result.rb'
require './fantasy_scorer.rb'
require './fantasy_participant.rb'

parsed_golfer_result_response = JSON.parse(RestClient.get 'http://samsandberg.com/themasters/', {accept: :json})['players']
golfer_results = parsed_golfer_result_response.map { |player| GolferResult.new(player) }

fantasy_picks = CSV.read('picks.csv')
fantasy_picks.shift
fantasy_participants = fantasy_picks.map { |participant_row| FantasyParticipant.new(participant_row) }

scorer = FantasyScorer.new(fantasy_participants, golfer_results)
scorer.calculate_each_participants_rounds

sorted_participants = fantasy_participants.sort_by { |participant| participant.overall_score_after_two_rounds }

iterations = 1
current_rank = 1
last_score = -9999999
sorted_participants.each do |participant|
	if participant.overall_score_after_two_rounds > last_score
		last_score = participant.overall_score_after_two_rounds
		current_rank = iterations
	end
	#puts "Rank: #{current_rank}, #{participant.name} - overall: #{participant.overall_score_after_two_rounds}"
	if participant.overall_score_after_two_rounds == -5
		puts "#{participant.name} - #{ participant.round2_top_golfers.map { |golfer| golfer.name }.sort }"
	end
	iterations += 1
end
