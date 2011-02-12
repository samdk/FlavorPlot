require 'rubygems'
require 'sinatra/base'
require 'json'
require 'socket'

class FlavorPlotServer < Sinatra::Base
  
  set :public, File.dirname(__FILE__) + '/public'
  
  get '/' do
    redirect '/index.html'
  end
  
  post '/ingredients' do		
    ingredients = JSON request.body.read.downcase
    
    output = []
    
    socket = TCPSocket.open('localhost', 9929)
    socket.puts ingredients.join("\t")
        
    input = socket.gets
    
    socket.close

    output = input.strip.split("\t").compact.map {|x| x.split(",").compact.map &:strip }
    	
  	count = {}
  	
    output.each do |recipe|
      in_common = recipe & ingredients
      recipe.each do |ing|
        in_common.each do |ing2|
          count[[ing2, ing]] ||= 0
          count[[ing2, ing]]  += in_common.size
        end
      end
    end
	
  	final_count = {}
	
  	count.each do |(i1, i2), v|		
  		final_count[i2] ||= 0
  		final_count[i2]  += v
  	end

  	goodies = final_count.to_a.sort_by(&:last).map(&:first) - ingredients
    
    JSON goodies.reverse[0,5]
  end
end
