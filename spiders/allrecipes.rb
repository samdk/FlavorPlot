
require "net/http"
require "uri"

PRINT_URL = "http://allrecipes.com/Recipe-Tools/Print/Recipe.aspx?origin=detail&servings=16&RecipeID="
RECIPE_URL = "http://allrecipes.com/"
BACK_TO_ORIGINAL_CLASS = "ctl00_CenterColumnPlaceHolder_printPage_lnkBackToRecipe"

class AllRecipeSpider

	def lookForRecipeLink(html)
		$1 if html.scan(/<a.+?id=\"ctl00_CenterColumnPlaceHolder_printPage_lnkBackToRecipe\".+?href="(.+?)"/)
	end

	def make_recipe_url(link) 
		RECIPE_URL + link[6..-1]
	end

	def parse(id)
		response = Net::HTTP.get URI.parse(PRINT_URL+id.to_s)
		link = lookForRecipeLink(response)
		recipeurl = make_recipe_url link
		puts recipeurl
		recipe_response = Net::HTTP.get URI.parse(recipeurl)
	end

end
#parse(nil, 17706, 17713)
