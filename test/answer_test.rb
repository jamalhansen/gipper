require 'test_helper'

class AnswerTest < Test::Unit::TestCase
  context "basic operations" do
    should "accept a single answer without equals as the correct and only answer" do
      output = Gipper::Answer.parse("5")
      assert_equal true, output.correct
      assert_equal "5", output.text
    end
  end

  context "feedback comment splitting" do
    setup do
      @answer = Gipper::Answer.new
    end

    should "return nils when passed empty string" do
      text, comment = @answer.split_comment("")
      assert_nil comment
      assert_nil text
    end

    should "return nils when passed nil" do
      text, comment = @answer.split_comment(nil)
      assert_nil comment
      assert_nil text
    end

    should "return nil comment and full text when no comment" do
      text, comment = @answer.split_comment("foo")
      assert_nil comment
      assert_equal "foo", text
    end

    should "return comment and text when feedback comment" do
      text, comment = @answer.split_comment("foo #bar")
      assert_equal "foo", text
      assert_equal "bar", comment
    end

    should "return full text when feedback comment is escaped" do
      text, comment = @answer.split_comment('foo \\#bar')
      assert_nil comment
      assert_equal 'foo \\#bar', text
    end
  end

  context "escape stripping" do
    setup do
      @answer = Gipper::Answer.new
    end

    should "not remove escaped feedback comments" do
      result = @answer.unescape("foo \\#comment")
      assert_equal "foo #comment", result
    end

    should "remove escapes from read string" do
      @answer.read('~ \\{\\}\\~\\=\\#foo', nil)
      assert_equal "{}~=#foo", @answer.text
    end
  end

  context "evaluating correctness" do
    setup do
      @answer = Gipper::Answer.new
    end

    should "view equals as correct" do
      result = @answer.split_correct("= foo")
      assert result[0]
      assert_equal "foo", result[1]
    end

    should "view twiddle as incorrect" do
      result = @answer.split_correct("~ foo")
      assert !result[0]
      assert_equal "foo", result[1]
    end
  end
end
