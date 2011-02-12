require 'rubygems'
require 'sinatra/base'
require 'json'
require 'mysql2'
require 'active_record'

class Ingredient < ActiveRecord::Base
  establish_connection adapter:  'mysql2',
                       host:     'localhost',
                       username: 'root',
                       password: '',
                       database: 'food_stage',
                       port:     3306
  
  set_table_name 'ingredient'
  
  def self.relevancy_candidates(things)
    sql = <<-SQL
      SELECT DISTINCT name, recipe_id
      FROM ingredient
      WHERE recipe_id IN (
        SELECT DISTINCT recipe_id
        FROM ingredient
        WHERE name IN (%s)
      )
    SQL
    
    puts sql % things.map{|x| %["#{x}"] }.join(', ')
    
    candidates = find_by_sql(sql % things.map {|x| %["#{x}"] }.join(', '))
  
  
    recipe_ids  = {}
    other_count = {}
    counts      = {}
  
    candidates.each do |c|
      (recipe_ids[c.recipe_id] ||= []) << c.name
    end
    
    things.each do |ing|
      recipe_ids.each do |id, names|
        if names.include? ing
          other_count[ing] ||= 0
          other_count[ing] += 1
          
          names.each do |name|
            counts[[ing, name]] ||= 0
            counts[[ing, name]] += 1
          end
        end
      end
    end
    
    counts.to_a.each do |a, b|
      counts[[a,b]] /= other_count[a].to_f
    end
  
    counts
  end
  
end

class FlavorPlotServer < Sinatra::Base
  
  set :public, File.dirname(__FILE__) + '/public'
  
end