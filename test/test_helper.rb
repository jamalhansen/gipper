require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'gipper'

class Test::Unit::TestCase
  def assert_answers correct, results
    assert_equal correct.length, results.length
    correct.each_with_index do |s, i|
      assert_equal s, results[i]
    end
  end

  def assert_false value
    assert FalseClass, value.class
  end
end
