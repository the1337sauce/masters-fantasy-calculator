require 'sinatra'
require './calculate_ranks'

get '/' do
  "#{calculate_ranks_response}"
end
