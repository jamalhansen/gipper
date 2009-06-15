require 'test_helper'

class AnswersTest < Test::Unit::TestCase
  def setup
    @answers = Gipper::Answers.new
  end


  context "answer splitting" do
    should "not split strings that do not contain answer delimiters" do
      answers = @answers.send :split_apart, "this is a single answer"
      assert_answers ["this is a single answer"], answers
    end

    should "split strings on twiddle" do
      answers = @answers.send :split_apart, "~this ~answer has ~three parts"
      assert_answers ["~this", "~answer has", "~three parts"], answers
    end
    
    should "split strings on equals" do
      answers = @answers.send :split_apart, "=this =answer has =three parts"
      assert_answers ["=this", "=answer has", "=three parts"], answers
    end
    
    should "split strings on equals and twiddles" do
      answers = @answers.send :split_apart, "~this =answer has ~three parts"
      assert_answers ["~this", "=answer has", "~three parts"], answers
    end
    
    should "not split strings on escaped equals and twiddles" do
      answers = @answers.send :split_apart, "~this \\=answer has ~two parts"
      assert_answers ["~this \\=answer has", "~two parts"], answers
    end

    should "split matching correctly" do
      answers = @answers.send :split_apart, "=waffle -> cone =cheese -> cheddar"
      assert_answers ["=waffle -> cone", "=cheese -> cheddar"], answers
    end

    should "be tolerant of input variance" do
      answers = @answers.send :split_apart, "  ~ %%%%%%% ~ UUUUUUUUU ~@@%^&* ~ 232323   = 2345       "
      assert_answers ["~ %%%%%%%", "~ UUUUUUUUU", "~@@%^&*", "~ 232323", "= 2345"], answers
    end

    should "get answer conmments" do
      answers = @answers.send :split_apart, "  ~ %%%%%%%#foo = UUUUUUUUU #bar"
      assert_answers ["~ %%%%%%%#foo", "= UUUUUUUUU #bar"], answers
    end

    should "get answer conmments when preceeded by a new line" do
      answers = @answers.send :split_apart, "~ Oompa\r\n#kun\r\n = Loompa\r\n #pyakun"
      assert_answers ["~ Oompa\r\n#kun", "= Loompa\r\n #pyakun"], answers
    end

    # If you want to use curly braces, { or }, or equal sign, =,
    # or # or ~ in a GIFT file (for example in a math question including
    # TeX expressions) you must "escape" them by preceding them with a \
    # directly in front of each { or } or =.
    should "ignore all escaped characters" do
      answers = @answers.send :split_apart, "~ \\{\\}\\~\\=\\#foo =\\{\\}\\~\\=\\#bar"
      assert_answers ["~ \\{\\}\\~\\=\\#foo", "=\\{\\}\\~\\=\\#bar"], answers
    end
  end

  context "splitting numerical answers" do
    setup do
      @answers = Gipper::Answers.new
    end
    
    should "determine numerical by a leading pound" do
      assert @answers.send :is_numerical?, "#333"
    end

    should "understand numerical answer format" do
      result = @answers.send :split_apart, "2000:3"
      assert_answers ["2000:3"], result
    end

    should "understand multiple numerical answer format" do
      result = @answers.send :split_apart, "=2000:0 #Whoopdee do! =%50%2000:3 #Yippers"
      assert_answers ["=2000:0 #Whoopdee do!", "=%50%2000:3 #Yippers"], result
    end
  end

  context "when determining the answer style" do
    should "return a style of true_false when it has one answer of true and no text" do
      @answers.parse("T")
      assert_equal :true_false, @answers.find_style
    end

    should "return a style of true_false when it has one answer of false and no text" do
      @answers.parse("F")
      assert_equal :true_false, @answers.find_style
    end

    should "return a style of multiple choice when it has more than one answer and text and only one answer is true" do
      @answers.parse("~foo =bar")
      assert_equal :multiple_choice, @answers.find_style
    end

    should "return a style of short answer when it has more than one answer and text and all answers are true" do
      @answers.parse("=foo =bar")
      assert_equal :short_answer, @answers.find_style
    end

    should "return a style of short answer when it has one true answer and text" do
      @answers.parse("=foo")
      assert_equal :short_answer, @answers.find_style
    end

    should "return a style of short answer when it has one true answer and text without equals" do
      @answers.parse("5")
      assert_equal :short_answer, @answers.find_style
    end

    should "return a style of matching when correct contains a string ->" do
      @answers.parse("=foo -> bar")
      assert_equal :matching, @answers.find_style
    end

    should "return a style of matching when correct contains a symbols ->" do
      @answers.parse("=:) -> smiley")
      assert_equal :matching, @answers.find_style
    end
  end
end
