class Parser
  
  BAD_WORDS = %w[ tbsp tbsp t tablespoon tablespoon tsp teaspoon
                  cup pint quart liter gallon ml
                  pinch can jar package taste
                  oz ounce lb pound fl
                  optional to cover for garnish loafe
                  whole chunk sliced diced chopped flaked package minced thinly corsely
                    finely slice beaten dried dry piece sifted cooked inch drop shredded
                  degrees
                ]
  
  def self.extract_ingredient(ing)
    ingredient = []
    ing = ing.downcase.gsub(/\(.*\)/,'').gsub(/[^a-z]/,'')
    ing.split.each do |word|
      word = word.singularize
      if BAD_WORDS.include?(word) || word =~ /\d/ || word.size <= 2
        ingredient = []
      else
        ingredient << word
      end
    end
    
    ingredient.uniq.join(' ')
  end
  
end