require 'csv'
require 'rest-client'
require 'json'

#3 = Full name
#4 = team name
#6-13 = golfers

class Player
	attr_reader :r1, :r2, :r3, :r4, :to_par, :pos, :name

	def initialize response_hash
		@r1 = response_hash['r1']
		@r2 = response_hash['r2']
		@r3 = response_hash['r3']
		@r4 = response_hash['r4']
		@to_par = response_hash['to_par']
		@pos = response_hash['pos']
		@name = response_hash['player']
		if @name.eql? 'Rafael Cabrera Bello'
			@name = 'Rafael Cabrera-Bello'
		end
		if @name.eql? "Sean O&#39;Hair"
			@name = "Sean O'Hair"
		end
	end

	def last_name
		@name.split(' ')[1]
	end

	def cut?
		@to_par.eql? 'CUT'
	end

	def to_s
		"#{@name} currently #{@to_par}"
	end

	def overall_score
		@r1.to_i + @r2.to_i - (72*2)
	end

end

parsed_players_response = JSON.parse(RestClient.get 'http://samsandberg.com/themasters/', {accept: :json})['players']
players = parsed_players_response.map { |player| Player.new(player) }.each_with_object({}) { |player, hash| hash[player.last_name] = player }

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
