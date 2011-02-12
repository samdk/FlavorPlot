require 'rubygems'
require 'sinatra/base'
require 'json'

class FlavorPlotServer < Sinatra::Base
  
  set :public, File.dirname(__FILE__) + '/public'
  
  post '/ingredients' do		
  	stuff = request.body.read
  	puts stuff
    ingredients = JSON stuff
    
    output = []
    
    File.open(File.join(File.dirname(__FILE__), '../pipe'), 'a+') do |f|
      f.puts "#{ingredients.join("\t")}"
      input = f.gets
      sleep 0.01 while (input = f.gets).nil?

      output = input.strip.split("\t").compact.map {|x| x.split(",").compact.map &:strip }
    end
    
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
