# To change this template, choose Tools | Templates
# and open the template in the editor.

module CustomAssertions
  def assert_answers correct, results
    assert_equal correct.length, results.length
    correct.each_with_index do |s, i|
      assert_equal s, results[i]
    end
  end

  def assert_question question, expected={}
    check_expected question, expected, :text_post
    check_expected question, expected, :answer
    check_expected question, expected, :title
    check_expected question, expected, :text
    check_expected question, expected, :style
    check_expected question, expected, :format
  end

  def assert_answer answer, expected={}
    check_expected answer, expected, :correct
    check_expected answer, expected, :text
    check_expected answer, expected, :comment
    check_expected answer, expected, :range
    check_expected answer, expected, :weight
  end

  def assert_false value
    assert FalseClass, value.class
  end

  def assert_question_parsing text, expected={}
    question = Gipper::Question.new

    question.parse text

    assert_question question, expected
  end

  def assert_answer_parsing text, expected={}
    answer = Gipper::Answer.new

    if expected[:numerical]
      answer.parse text, :numerical
    else
      answer.parse text
    end

    assert_answer answer, expected
  end

  def check_expected obj, expected, key
    if expected.has_key? key
      actual = (obj.send key.to_s)
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
