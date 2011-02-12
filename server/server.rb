require 'rubygems'
require 'sinatra/base'
require 'json'

class FlavorPlotServer < Sinatra::Base
  
  set :public, File.dirname(__FILE__) + '/public'
  
  post '/ingredients' do
    ingredients = JSON request.body.read
    
    output = []
    
    File.open(File.join(File.dirname(__FILE__), '../pipe'), 'a+') do |f|
      f.puts "#{ingredients.join("\t")}"
      input = f.gets
      sleep 0.01 while (input = f.gets).nil?

      output = input.strip.split("\t").map {|x| x.split(",").map &:strip }
    end
    
    JSON output
  end
  
end