require 'test_helper'

class QuestionTest < Test::Unit::TestCase
  def setup
    @q = Gipper::Question.new
  end

  context "(when passed a single question without comments or title)" do

    setup do
      @single_question = "wubble."
      @single_answer = "{=:) -> smiley}"
      single_input = @single_question + @single_answer

      @q.parse(single_input)
    end

    should "return the question" do
      assert_equal "wubble.", @q.text
    end

    should "return the answer" do
      assert_equal "smiley", @q.answer[0].correct
    end

    should "return the answer match" do
      assert_equal ":)", @q.answer[0].text
    end

    should "return the style" do
      assert_equal :matching, @q.style
    end
  end

  context "(when passed a single question with title but without comments)" do

    setup do
      @single_title = "SuperTitle"
      @single_question = "Titles are bad."
      @single_answer = "{F}"
      single_input = "::#{@single_title}::#{@single_question}#{@single_answer}"

      @q.parse(single_input)
    end

    should "return the question" do
      assert_equal @single_question, @q.text
    end

    should "return the answer" do
      assert_false @q.answer[0].correct
    end

    should "return the style" do
      assert_equal :true_false, @q.style
    end

    should "return the title" do
      assert_equal @single_title, @q.title
    end
  end

  context "when passed a question with escaped brackets" do
    should "ignore the brackets" do
      assert_question_parsing ' foo \\{escaped bracketed text\\}{T}',
        :text => "foo {escaped bracketed text}",
        :style => :true_false
    end


    should "handle all kinds of escaped stuff" do
      assert_question_parsing ' my crazy \\#\\~\\= question \\{escaped bracketed text\\}{=\\=\\#\\~foo#hi-yah}',
        :text => "my crazy #~= question {escaped bracketed text}",
        :style => :short_answer
    end
  end

  context "when determining the answer style" do
    should "return missing word when question_post is present" do
      assert_question_parsing "foo {=bar ~baz} cheese.",
        :text => "foo",
        :text_post => "cheese.",
        :style => :missing_word
    end
  end
end
