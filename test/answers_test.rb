require 'test_helper'

class AnswersTest < Test::Unit::TestCase
  context "answer splitting" do
    setup do
      @answers = Gipper::Answers.new
    end

    should "not split strings that do not contain answer delimiters" do
      parts = @answers.split_apart("this is a single answer")
      assert_equal 1, parts.length
      assert_equal "this is a single answer", parts[0]
    end

    should "split strings on twiddle" do
      parts = @answers.split_apart("~this ~answer has ~three parts")
      assert_equal 3, parts.length
      assert_equal "~this", parts[0]
      assert_equal "~answer has", parts[1]
      assert_equal "~three parts", parts[2]
    end
    
    should "split strings on equals" do
      parts = @answers.split_apart("=this =answer has =three parts")
      assert_equal 3, parts.length
      assert_equal "=this", parts[0]
      assert_equal "=answer has", parts[1]
      assert_equal "=three parts", parts[2]
    end
    
    should "split strings on equals and twiddles" do
      parts = @answers.split_apart("~this =answer has ~three parts")
      assert_equal 3, parts.length
      assert_equal "~this", parts[0]
      assert_equal "=answer has", parts[1]
      assert_equal "~three parts", parts[2]
    end
    
    should "not split strings on escaped equals and twiddles" do
      parts = @answers.split_apart("~this \\=answer has ~two parts")
      assert_equal 2, parts.length
      assert_equal "~this \\=answer has", parts[0]
      assert_equal "~two parts", parts[1]
    end
  end
end
