require 'rubygems'
require 'sinatra/base'
require 'json'
require 'socket'

class FlavorPlotServer < Sinatra::Base
  
  set :public, File.dirname(__FILE__) + '/public'
  
  post '/ingredients' do		
  	stuff = request.body.read
    ingredients = JSON stuff
    
    output = []
    
    socket = TCPSocket.open('localhost', 9929)
    socket.puts ingredients.join("\t")
        
    input = socket.gets
    
    socket.close

    output = input.strip.split("\t").compact.map {|x| x.split(",").compact.map &:strip }
    
    result_ingredients = output.flatten.uniq
	
  	count = {}
	
  	for ingredient in ingredients
  		for recipe in output
  			for ingredient2 in recipe
  				count[[ingredient, ingredient2]] ||= 0
  				count[[ingredient, ingredient2]] += 1
  			end
  		end
  	end
	
  	final_count = {}
	
  	count.each do |(i1, i2), v|		
  		final_count[i2] ||= 0
  		final_count[i2] += count[[i1,i2]] / output.size.to_f
  	end

  	goodies = final_count.to_a.sort_by(&:last).map(&:first) - ingredients
    
    JSON goodies.reverse[0,5]
  end
end
