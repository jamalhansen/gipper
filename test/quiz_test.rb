require 'test_helper'

class QuizTest < Test::Unit::TestCase
  context "simple question" do
    setup do
      @single_question = "This is a really lame question"
      @single_answer = "{T}"
    end

    should "remove commented lines before parsing" do
      file = File.open(File.join(File.dirname(__FILE__), *%w[fixtures begins_with_comment.txt]))
      Gipper::Quiz.new.iterate_through file.read do |q|
        assert_equal "1=1{T}", q
      end
    end
  end

  should "return just a question mark for question_post when question_post is just a question mark" do
    quiz = Gipper::Quiz.parse 'You say that, "money is the root of all evil", I ask you "what is the root of all {~honey ~bunnies =money}?"'
    assert_equal 'You say that, "money is the root of all evil", I ask you "what is the root of all', quiz[0].text
    assert_equal '?"', quiz[0].text_post

    answers = quiz[0].answer
    assert_false answers[0].correct
    assert_equal "honey", answers[0].text
    assert_false answers[1].correct
    assert_equal "bunnies", answers[1].text
    assert answers[2].correct
    assert_equal "money", answers[2].text
  end

  context "(when passed an empty string)" do
    should "should return an empty array" do
      quiz = Gipper::Quiz.parse("")
      assert_equal [], quiz
    end
  end

  context "(when passed more than one question)" do
    should "should return an array with questions" do
      q = []
      q << true_false_question("Weather Patterns in the Pacific Northwest", "Seattle is rainy.", "{T}")
      q << true_false_question("", "Seattle has lots of water.", "{T}")
      q << true_false_question("Accessories in the Pacific Northwest", "People in Seattle use umbrellas:", "{T}")

      multiple_input = "//opening comment\r\n//another comment\r\n\r\n\r\n#{q[0]}\r\n//this is a \r\n//couple rows of comments\r\n\r\n#{q[1]}\r\n\r\n#{q[2]}"

      Gipper::Quiz.new.iterate_through(multiple_input) do |qu|
        assert q.include?(qu)
      end
    end

    should "ignore whitespace between questions" do
      quiz = "a\r\n\t\r\nb\r\n      \r\nc\r\n\r\nd"
      count = 0

      Gipper::Quiz.new.iterate_through(quiz) do |qu|
        expected = ['a', 'b', 'c', 'd']
        assert_equal expected[count], qu
        count = count + 1
      end
      assert_equal 4, count
    end
  end
end
