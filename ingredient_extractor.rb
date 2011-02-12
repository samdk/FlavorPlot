require 'active_support/core_ext'

class Parser
  
  BAD_WORDS = %w[ tbsp tbsp t tablespoon tablespoon tsp teaspoon
                  cup pint quart liter gallon ml
                  pinch can jar package taste
                  oz ounce lb pound fl
                  optional to cover for garnish loafe
                  whole chunk sliced diced chopped flaked package minced thinly corsely
                  finely slice beaten dried dry piece sifted cooked inch drop shredded
                  degrees fresh dried canned
                  unsweetened sweetened allpurpose
                  large small medium thawed container melted nestle torn fullycooked campbell
                  uncooked grated dash toppings mazola envelope chunky quickrise ripe firm drained cubed
                  ground undrained campbells fatfree clove crushed
                ]
  
  def self.extract_ingredient(ing)
    ingredient = []
      
    ing.downcase.gsub(/\(.*\)/, '').split.each do |word|
      word = word.gsub(/[^a-z]/, '')
      if BAD_WORDS.include?(word.singularize) || word.size <= 2
        ingredient = []
      else
        ingredient << word
      end
    end
    
    if ingredient.size < 7 and !(ing = ingredient.uniq.join(' ')).blank?
      ing
    else
      raise "Couldn't figure '#{ing}' out, dude"
    end
  end
  
end

def go
  File.open(File.join(File.dirname(__FILE__), 'data', 'in', 'ingredients.csv')) do |f|
    f.each do |line|
      begin
        if line =~ /[\d]+,([\d]+),(.*)/
          puts "#{$1},#{Parser.extract_ingredient($2)}"
        end
      rescue StandardError => ex
        nil
      end
    end
  end
end

go