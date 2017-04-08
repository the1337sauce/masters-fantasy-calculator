require 'sinatra'
require './calculate_ranks'

get '/results' do
  @results = calculate_ranks_response
  erb :results
end
