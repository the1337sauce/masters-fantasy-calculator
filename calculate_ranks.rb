require 'csv'
require 'rest-client'
require 'json'
require './player.rb'
require './fantasy_scorer.rb'

#3 = Full name
#4 = team name
#6-13 = golfers

parsed_players_response = JSON.parse(RestClient.get 'http://samsandberg.com/themasters/', {accept: :json})['players']
players = parsed_players_response.map { |player| GolferResult.new(player) }.each_with_object({}) { |player, hash| hash[player.last_name] = player }
fantasy_picks = CSV.read('picks.csv')
fantasy_picks.shift
#puts fantasy_picks

name_to_scores = []
CSV.foreach('picks.csv') do |row|

	next if row[1] == 'Timestamp'
	person_in_pool_name = row[3]
	team_name = row[4]
	scores = []
	(6..13).each do |number|
		players_last_name = row[number].split(' ')[1]
		players_score = players[players_last_name].overall_score
		scores << players_score
	end
	summed_scores = scores.sort![0, 6].reduce(:+) #exclude last 2
	name_to_scores << [person_in_pool_name, summed_scores]

end

sorted_name_to_scores = name_to_scores.sort_by { |name_to_score| name_to_score[1]}

current_rank = 0
iterations = 1
last_score = -99999999999

#calculate overall ranks

sorted_name_to_scores.each do |sorted_name_to_scores|
	name = sorted_name_to_scores[0]
	score = sorted_name_to_scores[1]
	if score > last_score
		last_score = score
		current_rank = iterations
	end
	iterations += 1
	puts "Rank: #{current_rank} - #{name} is: #{score}"
end
