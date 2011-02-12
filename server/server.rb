require 'rubygems'
require 'sinatra/base'
require 'json'

require File.dirname(__FILE__) + '/../db'

class FlavorPlotServer < Sinatra::Base
  
  set :public, File.dirname(__FILE__) + '/public'
  
  before { @db = Db.new(File.dirname(__FILE__) + '/../allrecipes.unprocessed.db') }
  
  get '/' do
    @db.data.to_json
  end
  
  get '/:ing/:ing2' do |a, b|
    @db.get(a, b).to_json
  end
  
  get '/:ing' do |i|
    @db.get(i).to_a.sort_by{|(i,p)|-p}.map{|(i,p)| {'ingredient' => i, 'relation' => p}}.to_json
  end
  
end