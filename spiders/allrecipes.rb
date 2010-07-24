
require "net/http"
require "uri"

PRINT_URL = "http://allrecipes.com/Recipe-Tools/Print/Recipe.aspx?origin=detail&servings=16&RecipeID="
RECIPE_URL = "http://allrecipes.com/"
BACK_TO_ORIGINAL_CLASS = "ctl00_CenterColumnPlaceHolder_printPage_lnkBackToRecipe"


def lookForRecipeLink(html)
	$1 if html.scan(/<a.+?id=\"ctl00_CenterColumnPlaceHolder_printPage_lnkBackToRecipe\".+?href="(.+?)"/)
end

def make_recipe_url(link) 
	RECIPE_URL + link[6..-1]
end

def parse(parser, start, finish)
	start.upto(finish) do |i|
		response = Net::HTTP.get URI.parse(PRINT_URL+i.to_s)
		link = lookForRecipeLink(response)
		if link 
			#puts link
			recipeurl = make_recipe_url link
			puts recipeurl
			recipe_response = Net::HTTP.get URI.parse(recipeurl)
			parser.parse(recipe_response)
		end
	end
end


#parse(nil, 17706, 17713)
