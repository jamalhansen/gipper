require 'test_helper'

class QuestionTest < Test::Unit::TestCase
  context "(when passed a single question without comments or title)" do

    setup do
      @single_question = "wubble."
      @single_answer = "{=:) -> smiley}"
      single_input = @single_question + @single_answer

      @question = Gipper::Question.parse(single_input)
    end

    should "return the question" do
      assert_equal "wubble.", @question.text
    end

    should "return the answer" do
      assert_equal "smiley", @question.answer[0].correct
    end

    should "return the answer match" do
      assert_equal ":)", @question.answer[0].text
    end

    should "return the style" do
      assert_equal :matching, @question.style
    end
  end

  context "(when passed a single question with title but without comments)" do

    setup do
      @single_title = "SuperTitle"
      @single_question = "Titles are bad."
      @single_answer = "{F}"
      single_input = "::#{@single_title}::#{@single_question}#{@single_answer}"

      @question = Gipper::Question.parse(single_input)
    end

    should "return the question" do
      assert_equal @single_question, @question.text
    end

    should "return the answer" do
      assert_false @question.answer[0].correct
    end

    should "return the style" do
      assert_equal :true_false, @question.style
    end

    should "return the title" do
      assert_equal @single_title, @question.title
    end
  end

  context "when passed a question with escaped brackets" do
    should "ignore the brackets" do
      question = Gipper::Question.parse(' foo \{escaped bracketed text\}{T}')
      assert_equal "foo {escaped bracketed text}", question.text
      assert_equal :true_false, question.style
      assert question.answer[0].correct
    end


    should "handle all kinds of escaped stuff" do
      question = Gipper::Question.parse(' my crazy \#\~\= question \{escaped bracketed text\}{=\=\#\~foo#hi-yah}')
      assert_equal "my crazy #~= question {escaped bracketed text}", question.text
      assert_equal :short_answer, question.style
      assert question.answer[0].correct
      assert_equal '=#~foo', question.answer[0].text
      assert_equal 'hi-yah', question.answer[0].comment
    end
  end

  context "when determining the answer style" do
    should "return a style of true_false when it has one answer of true and no text" do
      question = Gipper::Question.parse("Foo{T}")
      assert_equal :true_false, question.style
    end

    should "return a style of true_false when it has one answer of false and no text" do
      question = Gipper::Question.parse("Foo{F}")
      assert_equal :true_false, question.style
    end

    should "return a style of multiple choice when it has more than one answer and text and only one answer is true" do
      question = Gipper::Question.parse("Foo{~foo =bar}")
      assert_equal :multiple_choice, question.style
    end

    should "return a style of short answer when it has more than one answer and text and all answers are true" do
      question = Gipper::Question.parse("Foo{=foo =bar}")
      assert_equal :short_answer, question.style
    end

    should "return a style of short answer when it has one true answer and text" do
      question = Gipper::Question.parse("Foo{=foo}")
      assert_equal :short_answer, question.style
    end

    should "return a style of short answer when it has one true answer and text without equals" do
      question = Gipper::Question.parse("Foo{5}")
      assert_equal :short_answer, question.style
    end

    should "return a style of matching when correct contains a string ->" do
      question = Gipper::Question.parse("Foo{=foo -> bar}")
      assert_equal :matching, question.style
    end

    should "return a style of matching when correct contains a symbols ->" do
      question = Gipper::Question.parse("Foo{=:) -> smiley}")
      assert_equal :matching, question.style
    end

    should "return missing word when question_post is present" do
      question = Gipper::Question.parse "foo {=bar ~baz} cheese."
      assert_equal "foo", question.text
      assert_equal "cheese.", question.text_post
      assert_equal :missing_word, question.style
    end
  end
end
