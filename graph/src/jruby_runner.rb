require 'java'
require 'ga.jar'

module FlavorPlot
  include_package 'flavorplot'
end

require File.dirname(__FILE__) + '/../db'

db = Db.new File.dirname(__FILE__) + '/../data.db'

#ARGV
# 0 => max gens
# 1 => pop size
# 2 => print every

pairs = []
db.each do |i, is|
  is.each_pair do |j, v|
    pairs << FlavorPlot::IngredientPair.new(i, j, v) if i > j
  end
end 

max_gens = ARGV[0].to_i
pop_size = ARGV[1].to_i
print_every = ARGV[2].to_i

ga = FlavorPlot::GaOptimizer.from_ingredient_pairs pairs, max_gens, pop_size

(max_gens/print_every).times do
  ga.run(print_every)
  puts ga.best.fitness
  puts ga.best.inspect
end

