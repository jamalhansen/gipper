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


  should "accept a single answer without equals as the correct and only answer" do
    output = Gipper::Answer.parse("5")
    assert output.correct
    assert_equal "5", output.text
  end

  should "have a default weight of nil" do
    output = Gipper::Answer.parse("foo" )
    assert_nil output.weight
  end

  should "parse weight from numerical and non-numerical answers" do
    output = Gipper::Answer.parse("%50%yadda yadda" )
    assert_equal 50, output.weight
  end

  should "use decimals for numerical answers" do
    output = Gipper::Answer.parse("5.6765", :numerical )
    assert_equal 5.6765, output.correct
    assert_nil output.weight
    assert_equal 0, output.range
  end

  should "handle alternate range format for numerical answers" do
    output = Gipper::Answer.parse("5.1..5.9", :numerical )
    assert_equal 5.5, output.correct
    assert_nil output.weight
    assert_equal 4, (output.range * 10).to_i

    output = Gipper::Answer.parse("5.6765..5.6766", :numerical )
    assert_equal 5.67655, output.correct
    assert_nil output.weight
    assert_equal 5, (output.range * 100000).round
  end

  context "parsing true false questions" do
    should "recognize comments" do
      output = Gipper::Answer.parse(" T#foo" )
      assert output.correct
      assert_nil output.text
      assert_equal "foo", output.comment
    end

    should "be tolerant of input variance" do
      assert Gipper::Answer.parse(" T" ).correct
      assert Gipper::Answer.parse("TrUE ").correct
      assert Gipper::Answer.parse(" true").correct
      assert Gipper::Answer.parse(" t ").correct
      assert_equal false, Gipper::Answer.parse("F ").correct
      assert_equal false, Gipper::Answer.parse("  false ").correct
      assert_equal false, Gipper::Answer.parse(" faLse").correct
      assert_equal false, Gipper::Answer.parse(" f ").correct
    end
  end

  should "identify matching questions and place the match into correct" do
    answer = Gipper::Answer.parse("=waffle -> cone")
    assert_equal "waffle", answer.text
    assert_equal "cone", answer.correct
  end

  should "be tolerant of input variance" do
    answer = Gipper::Answer.parse("~ %%%%%%%")
    assert_equal "%%%%%%%", answer.text
    assert_equal false, answer.correct

    answer = Gipper::Answer.parse("~UUUUUUUUU")
    assert_equal "UUUUUUUUU", answer.text
    assert_equal false, answer.correct
  end

  should "get answer conmments" do
    answer = Gipper::Answer.parse("~ %%%%%%%#foo")
    assert_equal "%%%%%%%", answer.text
    assert_false answer.correct
    assert_equal "foo", answer.comment
  end

  should "get answer conmments when preceeded by a new line" do
    answer = Gipper::Answer.parse("~ Oompa\r\n#kun")
    assert_equal "Oompa", answer.text
    assert_false answer.correct
    assert_equal "kun", answer.comment
  end

  # If you want to use curly braces, { or }, or equal sign, =,
  # or # or ~ in a GIFT file (for example in a math question including
  # TeX expressions) you must "escape" them by preceding them with a \
  # directly in front of each { or } or =.
  should "ignore all escaped characters" do
    answer = Gipper::Answer.parse("~ \\{\\}\\~\\=\\#foo")
    assert_equal "{}~=#foo", answer.text
    assert_false answer.correct
    assert_nil answer.comment
  end

  context "numerical answers" do
    should "understand numerical answer format" do
      answer = Gipper::Answer.parse("2000:3", :numerical)
      assert_equal 2000, answer.correct
      assert_equal 3, answer.range
      assert_nil answer.weight
      assert_nil answer.comment
    end

    should "simple numerical answer format" do
      answer = Gipper::Answer.parse("=2000:0 #Whoopdee do!", :numerical)
      assert_equal 2000, answer.correct
      assert_equal 0, answer.range
      assert_nil answer.weight
      assert_equal "Whoopdee do!", answer.comment
    end

    should "percent based numerical answer format" do
      answer = Gipper::Answer.parse("=%50%2000:3 #Yippers", :numerical)
      assert_equal 2000, answer.correct
      assert_equal 3, answer.range
      assert_equal 50, answer.weight
      assert_equal "Yippers", answer.comment
    end
  end
end