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

  def true_false_question title, question, answer
    if title
      "::#{title}::#{question}#{answer}"
    else
      "#{question}#{answer}"
    end
  end
  
  def assert_answer_parsing text, expected={}
    answer = Gipper::Answer.new

    if expected[:numerical]
      answer.parse text, :numerical
    else
      answer.parse text
    end

    check_expected answer, expected, :correct
    check_expected answer, expected, :text
    check_expected answer, expected, :comment
    check_expected answer, expected, :range
    check_expected answer, expected, :weight
  end

  def check_expected answer, expected, key
    if expected.has_key? key
      actual = (answer.send key.to_s)
      if expected[key].nil?
        assert_nil actual, "key #{key.to_s} expected to be nil got #{actual}"
      else
        if actual.class == Float
          assert_in_delta expected[key], actual, 0.00001, "key #{key.to_s} expected #{expected[key]} got #{actual} with tolerence of .00001"
        else
          assert_equal expected[key], actual, "key #{key.to_s} expected #{expected[key]} got #{actual}"
        end

      end
    end
  end
end
