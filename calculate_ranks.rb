require 'csv'
require 'rest-client'
require 'json'

#3 = Full name
#4 = team name
#6-13 = golfers

parsed_response = JSON.parse(RestClient.get 'http://samsandberg.com/themasters/', {accept: :json})['players']
results = parsed_response.each_with_object({}) { |player_hash, hash| hash[player_hash['player'].split(' ')[1]] = player_hash['to_par'] }

name_to_scores = []
CSV.foreach('picks.csv') do |row|
	next if row[1] == 'Timestamp'
	name = row[3]
	team_name = row[4]
	scores = []
	(6..13).each do |number|
		players_last_name = row[number].split(' ')[1]
		players_score = results[players_last_name].to_i
		if name.eql? "Nate Linsky"
			puts players_last_name
			puts players_score
		end
		scores << players_score
	end
	sorted_scores = scores.sort!
	scores_we_care_about = sorted_scores[0, 6] #exclude last 2
	summed = scores_we_care_about.reduce(:+)
	name_to_scores << [name, summed]
end
sorted_name_to_scores = name_to_scores.sort_by { |name_to_score| name_to_score[1]}

current_rank = 0
last_score = -99999999999

sorted_name_to_scores.each do |sorted_name_to_scores|
	name = sorted_name_to_scores[0]
	score = sorted_name_to_scores[1]
	if score > last_score
		last_score = score
		current_rank = current_rank + 1
	end
	puts "Rank: #{current_rank} - #{name} is: #{score}"
end
