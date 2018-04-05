require 'sinatra'
require './calculate_ranks'
require 'pry'

get '/results' do
  begin
  	@results = calculate_ranks_response
  	erb :results
  rescue JSON::ParserError
  	"The scoring API is currently down :-(. The leaderboard will be back up when it's fixed!"
  end
end
