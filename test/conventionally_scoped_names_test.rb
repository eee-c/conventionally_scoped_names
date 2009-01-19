require File.dirname(__FILE__) + '/test_helper.rb'

class ConventionallyScopedNamesTest < Test::Unit::TestCase
  def setup
    load_schema
  end

  def test_schema_has_loaded_correctly
    assert_equal [], Post.all
  end

end
