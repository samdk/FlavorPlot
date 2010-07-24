require 'test/unit'
require File.dirname(__FILE__) + '/../ingest/parser'

class TestParser < Test::Unit::TestCase
  def test_extract_ingredient
    pairs = {
      'spinach'       => '2 cups spinach',
      'tomato'        => 'cup tomato',
      'celery'        => 'celery',
      'braised lamb'  => '1 lb. braised lamb',
      'garlic, peeled'=> '1 garlic, peeled'
    }
    pairs.each do |right, test|
      assert_equal right, Parser.extract_ingredient(test)
    end
  end
end