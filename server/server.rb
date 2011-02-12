require 'rubygems'
require 'sinatra/base'
require 'json'

class FlavorPlotServer < Sinatra::Base
  
  set :public, File.dirname(__FILE__) + '/public'
  
  post '/ingredients' do
    ingredients = JSON[request.body.read]
    
    File.open(File.join(File.dirname(__FILE__), '../pipe')) do |f|
      f.
    end
  end
  
end