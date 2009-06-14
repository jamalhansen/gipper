require 'test_helper'

class AnswerTest < Test::Unit::TestCase
  def setup
    @answer = Gipper::Answer.new
  end

  should "accept a single answer without equals as the correct and only answer" do
    @answer.parse("5")
    assert_equal true, @answer.correct
    assert_equal "5", @answer.text
  end

  context "determining weight" do
    should "have a default weight of nil" do
      @answer.parse("foo" )
      assert_nil @answer.weight
    end

    should "parse weight from numerical and non-numerical answers" do
      @answer.parse("%50%yadda yadda" )
      assert_equal 50, @answer.weight
    end
  end

  should "use decimals for numerical answers" do
    assert_answer_parsing "5.6765", :correct => 5.6765, :weight => nil, :range => 0, :numerical => true
  end

  should "handle alternate range format for numerical answers" do
    assert_answer_parsing "5.1..5.9", :correct => 5.5, :weight => nil, :range => 0.4, :numerical => true
  end

  should "handle alternate range format for numerical answers with multiple decimal places" do
    assert_answer_parsing "5.6765..5.6766", :correct => 5.67655, :weight => nil, :range => 0.00005, :numerical => true
  end

  context "parsing true false questions" do
    should "recognize feedback" do
      assert_answer_parsing " T#foo", :correct => true, :text => nil, :comment => "foo"
    end

    should "be tolerant of input variance" do
      assert_answer_parsing " T", :correct => true
      assert_answer_parsing "TrUE ", :correct => true
      assert_answer_parsing " true", :correct => true
      assert_answer_parsing " t ", :correct => true
      assert_answer_parsing "F ", :correct => false
      assert_answer_parsing "  false ", :correct => false
      assert_answer_parsing " faLse", :correct => false
      assert_answer_parsing " f ", :correct => false
    end
  end

  should "identify matching questions and place the match into correct" do
    assert_answer_parsing "=waffle -> cone", :correct => "cone", :text => "waffle"
  end

  should "be tolerant of input variance" do
    assert_answer_parsing "~ %%%%%%%", :correct => false, :text => "%%%%%%%"
    assert_answer_parsing "~UUUUUUUUU", :correct => false, :text => "UUUUUUUUU"
  end

  should "get answer conmments" do
    assert_answer_parsing "~ %%%%%%%#foo", :correct => false, :text => "%%%%%%%", :comment => "foo"
  end

  should "get answer conmments when preceeded by a new line" do
    assert_answer_parsing "~ Oompa\r\n#kun", :correct => false, :text => "Oompa", :comment => "kun"
  end

  # If you want to use curly braces, { or }, or equal sign, =,
  # or # or ~ in a GIFT file (for example in a math question including
  # TeX expressions) you must "escape" them by preceding them with a \
  # directly in front of each { or } or =.
  should "ignore all escaped characters" do
    assert_answer_parsing "~ \\{\\}\\~\\=\\#foo", :correct => false, :text => "{}~=#foo", :comment => nil
  end

  context "numerical answers" do
    should "understand numerical answer format" do
      assert_answer_parsing "2000:3", :correct => 2000, :range => 3, :text => nil, :comment => nil, :weight => nil, :numerical => true
    end

    should "simple numerical answer format" do
      assert_answer_parsing "=2000:0 #Whoopdee do!", :correct => 2000, :range => 0, :text => nil, :comment => "Whoopdee do!", :weight => nil, :numerical => true
    end

    should "percent based numerical answer format" do
      assert_answer_parsing "=%50%2000:3 #Yippers", :correct => 2000, :range => 3, :text => nil, :comment => "Yippers", :weight => 50, :numerical => true
    end
  end


  context "feedback comment splitting" do
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
    should "not remove escaped feedback comments" do
      result = @answer.unescape("foo \\#comment")
      assert_equal "foo #comment", result
    end

    should "remove escapes from read string" do
      @answer.parse('~ \\{\\}\\~\\=\\#foo', nil)
      assert_equal "{}~=#foo", @answer.text
    end
  end

  context "evaluating correctness" do
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
