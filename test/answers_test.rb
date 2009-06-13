require 'test_helper'

class AnswersTest < Test::Unit::TestCase
  context "answer splitting" do
    setup do
      @answers = Gipper::Answers.new
    end

    should "not split strings that do not contain answer delimiters" do
      answers = @answers.split_apart("this is a single answer")
      assert_answers ["this is a single answer"], answers
    end

    should "split strings on twiddle" do
      answers = @answers.split_apart("~this ~answer has ~three parts")
      assert_answers ["~this", "~answer has", "~three parts"], answers
    end
    
    should "split strings on equals" do
      answers = @answers.split_apart("=this =answer has =three parts")
      assert_answers ["=this", "=answer has", "=three parts"], answers
    end
    
    should "split strings on equals and twiddles" do
      answers = @answers.split_apart("~this =answer has ~three parts")
      assert_answers ["~this", "=answer has", "~three parts"], answers
    end
    
    should "not split strings on escaped equals and twiddles" do
      answers = @answers.split_apart("~this \\=answer has ~two parts")
      assert_answers ["~this \\=answer has", "~two parts"], answers
    end

    should "split matching correctly" do
      answers = @answers.split_apart("=waffle -> cone =cheese -> cheddar")
      assert_answers ["=waffle -> cone", "=cheese -> cheddar"], answers
    end

    should "be tolerant of input variance" do
      answers = @answers.split_apart("  ~ %%%%%%% ~ UUUUUUUUU ~@@%^&* ~ 232323   = 2345       ")
      assert_answers ["~ %%%%%%%", "~ UUUUUUUUU", "~@@%^&*", "~ 232323", "= 2345"], answers
    end

    should "get answer conmments" do
      answers = @answers.split_apart("  ~ %%%%%%%#foo = UUUUUUUUU #bar")
      assert_answers ["~ %%%%%%%#foo", "= UUUUUUUUU #bar"], answers
    end

    should "get answer conmments when preceeded by a new line" do
      answers = @answers.split_apart "~ Oompa\r\n#kun\r\n = Loompa\r\n #pyakun"
      assert_answers ["~ Oompa\r\n#kun", "= Loompa\r\n #pyakun"], answers
    end

    # If you want to use curly braces, { or }, or equal sign, =,
    # or # or ~ in a GIFT file (for example in a math question including
    # TeX expressions) you must "escape" them by preceding them with a \
    # directly in front of each { or } or =.
    should "ignore all escaped characters" do
      answers = @answers.split_apart("~ \\{\\}\\~\\=\\#foo =\\{\\}\\~\\=\\#bar")
      assert_answers ["~ \\{\\}\\~\\=\\#foo", "=\\{\\}\\~\\=\\#bar"], answers
    end
  end

  context "splitting numerical answers" do
    setup do
      @answers = Gipper::Answers.new
      @answers.style_hint = :numerical
    end

    should "understand numerical answer format" do
      answers = @answers.split_apart("2000:3")
      assert_answers ["2000:3"], answers
    end

    should "understand multiple numerical answer format" do
      answers = @answers.split_apart("=2000:0 #Whoopdee do! =%50%2000:3 #Yippers")
      assert_answers ["=2000:0 #Whoopdee do!", "=%50%2000:3 #Yippers"], answers
    end
  end
end
