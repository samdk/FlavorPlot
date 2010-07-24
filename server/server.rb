require 'rubygems'
require 'sinatra/base'
require 'json'

require File.dirname(__FILE__) + '/../db'

class FlavorPlotServer < Sinatra::Base
  
  before { @db = Db.new(File.dirname(__FILE__) + '/../foo') }
  
  get '/' do
    @db.data.to_json
  end
  
  get '/:ing/:ing2' do |a, b|
    @db.get(a, b).to_json
  end
  
  get '/:ing' do |i|
    @db.get(i).to_json
  end
  
end