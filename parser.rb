class Parser
  
  UNITS = %w[ tbsp tbsp t tablespoon tablespoons tsp tsps ts teaspoon teaspoons
              cups cup pint pints quart quarts liter liters gallon gallons ml
              pinch
              oz ounces lb pound lbs fl
            ]
  
  def self.extract_ingredient(ing)
    ingredient = []
    
    ing.split.each do |word|
      ingredient << word unless UNITS.include?(word.downcase.gsub('.','')) || word =~ /\d/
    end
    
    ingredient.join(' ')
  end
  
end