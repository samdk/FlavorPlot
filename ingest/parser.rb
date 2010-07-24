class Parser
  
  UNITS = %w[ tbsp tbsp t tablespoon tablespoons tsp tsps ts teaspoon teaspoons
              cups cup pint pints quart quarts liter liters gallon gallons ml
              pinch cans can
              oz ounce ounces lb pound lbs fl
            ]
  
  def self.extract_ingredient(ing)
    ingredient = []
    ing = ing.downcase
    ing.split.each do |word|
      if UNITS.include?(word.gsub(/\W/,''))
        ingredient = []
      elsif word =~ /\d/
        ingredient = []
      else
        ingredient << word
      end
    end
    
    ingredient.join(' ')
  end
  
end