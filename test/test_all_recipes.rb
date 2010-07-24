require 'test/unit'
require File.dirname(__FILE__) + '/../ingest/parsers/all_recipes'

class TestAllRecipes < Test::Unit::TestCase
  def test_basic
    html = <<EOS
    <div class="ingredients" style="margin-top: 10px;"> 
            <h3> 
                Ingredients</h3> 
                    <ul> 
                    <li class="plaincharacterwrap"> 
                        1/4 cup Dijon mustard</li> 
                    <li class="plaincharacterwrap"> 
                        2 tablespoons fresh lemon juice</li> 
                    <li class="plaincharacterwrap"> 
                        1 1/2 teaspoons Worcestershire sauce</li> 
                    </ul> 
        </div> 
EOS
    assert_equal ['Dijon mustard', 'fresh lemon juice', 'Worcestershire sauce'], AllRecipesParser.parse(html)
  end
end