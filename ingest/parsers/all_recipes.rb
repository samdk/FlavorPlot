require File.dirname(__FILE__) + '/../parser'

class AllRecipesParser < Parser
  def self.parse(html)
    html = html.gsub("\n", '')
    ingredients = []
    if html =~ /<div class="ingredients"[^>]+>(.+)<\/div>/
      $1.scan(/wrap">([^<]+)/) do |match|
        ing = extract_ingredient(match[0])
        ingredients << ing unless ing == ''
      end
    end
    ingredients
  end
end