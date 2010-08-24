class Parser
  
  BAD_WORDS = %w[ tbsp tbsp t tablespoon tablespoon tsp teaspoon
                  cup pint quart liter gallon ml
                  pinch can jar package taste
                  oz ounce lb pound fl
                  optional to cover for garnish loafe
                  whole chunk sliced diced chopped flaked package minced thinly corsely
                    finely slice beaten dried dry piece sifted cooked inch drop shredded
                  degrees fresh dried canned
                ]
  
  def self.extract_ingredient(ing)
    ingredient = []
    ing = ing.downcase.gsub(/\(.*\)/,'')
    ing.split.each do |word|
      word = word.gsub(/[^a-z]/,'')
      if BAD_WORDS.include?(word.singularize) || word =~ /\d/ || word.size <= 2
        ingredient = []
      else
        ingredient << word
      end
    end
    
    if ingredient.size < 5
      ingredient.uniq.join(' ')
    else
      ''
    end
  end
  
end