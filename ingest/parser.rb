class Parser
  
  BAD_WORDS = %w[ tbsp tbsp t tablespoon tablespoon tsp teaspoon
                  cup pint quart liter gallon ml
                  pinch can jar package
                  oz ounce lb pound fl
                  optional to cover
                  degrees
                ]
  
  def self.extract_ingredient(ing)
    ingredient = []
    ing = ing.downcase.gsub(/\(.*\)/,'')
    ing.split.each do |word|
      word = word.singularize
      if BAD_WORDS.include?(word.gsub(/\W/,'')) || word =~ /\d/ || word.size <= 2
        ingredient = []
      else
        ingredient << word
      end
    end
    
    ingredient.uniq.join(' ')
  end
  
end