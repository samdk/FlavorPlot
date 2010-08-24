require 'net/http'
require 'uri'
require 'csv'

require 'rubygems'
require 'active_support'

require File.dirname(__FILE__) + '/parser'
require File.dirname(__FILE__) + '/spider'
require File.dirname(__FILE__) + '/../db'

Dir.glob('parsers/*').each {|f| require f}
Dir.glob('spiders/*').each {|f| require f}

ROOT = File.dirname(__FILE__) + '/../'

class IngestManager
  
  def self.ingest
    parse_raw_ingredients_csv
    normalize_db
    csvize_normalized_db
  end
  def self.parse_raw_ingredients_csv
    data = {}
    CSV.open(ROOT + '/data/in/ingredients.csv', 'r') do |row|
      (data[row[1]] ||= []) << Parser.extract_ingredient(row[2])
    end
    
    
    db = Db.new
    data.each_pair do |recipe, ings|
      ings.each_with_index do |i, idx|
        ings[(idx+1)..-1].each do |j|
          db.add(i, j)
        end
      end
    end
  
    db.save_as 'allrecipes.unprocessed.db'
  end
  
  def self.normalize_db
    db = Db.new 'allrecipes.unprocessed.db'
    normDb = Db.new
    db.each do |i, related|
      count = related.to_a.inject(0) {|m,(i,n)| m + n }
      related.each do |j, num|
        if i < j
          both = count + db.get(j).to_a.inject(0) {|m,(i,n)| m + n}
          normDb.add i, j, (num.to_f / both.to_f)
        end
      end
    end
    
    normDb.save_as 'allrecipes.db'
  end
  
  def self.csvize_normalized_db
    normDb = Db.new 'allrecipes.db'
    CSV.open(ROOT + '/data/out/allrecipes.csv', 'w') do |writer|
      normDb.each do |i, js|
        js.each do |j, n|
          writer << [i, j, n]
        end
      end
    end
  end
end