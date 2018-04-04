require 'sinatra'
require './calculate_ranks'
require 'pry'

get '/results' do
  @results = calculate_ranks_response
  erb :results
end
