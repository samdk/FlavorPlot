class AllRecipesSpider < Spider
  PRINT_URL              = "http://allrecipes.com/Recipe-Tools/Print/Recipe.aspx?origin=detail&servings=16&RecipeID="
  RECIPE_URL             = "http://allrecipes.com/"
  BACK_TO_ORIGINAL_CLASS = "ctl00_CenterColumnPlaceHolder_printPage_lnkBackToRecipe"
	
	def initialize
		@start = 7000
		@finish = 7015
		@current = @start
	end

	def recipe_link(html)
		$1 if html.scan /<a.*id=\"ctl00_CenterColumnPlaceHolder_printPage_lnkBackToRecipe\".*href="(.*)"/
	end

	def make_recipe_url(link) 
		RECIPE_URL + link[6..-1]
	end

	def parse(id)
		response = Net::HTTP.get URI.parse(PRINT_URL+id.to_s)
		recipe_url = make_recipe_url(recipe_link(response))
		Net::HTTP.get URI.parse(recipe_url)
	end

	def next?
		@current < @finish
	end
	
	def next_recipe
		@current+=1
		@current+=1 until ((result = parse(@current)) || ! next?)
		result
	end 
end
