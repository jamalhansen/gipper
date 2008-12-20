require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Question do
  describe "(when passed a single question without comments or title)" do
    
    before(:each) do
      @single_question = "wubble."
      @single_answer = "{=:) -> smiley}"
      single_input = @single_question + @single_answer
      
      @question = Gipper::Question.parse(single_input)
    end
    
    it "should return the question" do
      @question.text.should eql("wubble.")
    end
    
    it "should return the answer" do
      @question.answer[0].correct.should eql("smiley")
    end
    
    it "should return the answer" do
      @question.answer[0].text.should eql(":)")
    end
    
    it "should return the style" do
      @question.style.should eql(:matching)
    end
  end
  
  describe "(when passed a single question with title but without comments)" do
    
    before(:each) do
      @single_title = "SuperTitle"
      @single_question = "Titles are bad."
      @single_answer = "{F}"
      single_input = "::#{@single_title}::#{@single_question}#{@single_answer}"
      
      @question = Gipper::Question.parse(single_input)
    end

    it "should return the question" do
      @question.text.should eql(@single_question)
    end
    
    it "should return the answer" do
      @question.answer[0].correct.should eql(:false)
    end
    
    it "should return the style" do
      @question.style.should eql(:true_false)
    end
    
    it "should return the title" do
      @question.title.should eql(@single_title)
    end
  end
  
  describe "when passed a question with escaped brackets" do
    it "should ignore the brackets" do
      question = Gipper::Question.parse(' foo \{escaped bracketed text\}{T}')
      question.text.should eql("foo {escaped bracketed text}")
      question.style.should eql(:true_false)
      question.answer[0].correct.should eql(:true)
    end
    
    
    it "should handle all kinds of escaped stuff" do
      question = Gipper::Question.parse(' my crazy \#\~\= question \{escaped bracketed text\}{=\=\#\~foo#hi-yah}')
      question.text.should eql("my crazy #~= question {escaped bracketed text}")
      question.style.should eql(:short_answer)
      question.answer[0].correct.should eql(:true)
      question.answer[0].text.should eql('=#~foo')
      question.answer[0].comment.should eql('hi-yah')
    end
  end
 
  describe "when determining the answer style" do
    it "should return a style of true_false when it has one answer of true and no text" do
      question = Gipper::Question.parse("Foo{T}")
      question.style.should eql(:true_false)
    end
    
    it "should return a style of true_false when it has one answer of false and no text" do
      question = Gipper::Question.parse("Foo{F}")
      question.style.should eql(:true_false)
    end
    
    it "should return a style of multiple choice when it has more than one answer and text and only one answer is true" do
      question = Gipper::Question.parse("Foo{~foo =bar}")
      question.style.should eql(:multiple_choice)
    end
    
    it "should return a style of short answer when it has more than one answer and text and all answers are true" do
      question = Gipper::Question.parse("Foo{=foo =bar}")
      question.style.should eql(:short_answer)
    end
    
    it "should return a style of short answer when it has one true answer and text" do
      question = Gipper::Question.parse("Foo{=foo}")
      question.style.should eql(:short_answer)
    end
    
    it "should return a style of matching when correct contains a string ->" do
      question = Gipper::Question.parse("Foo{=foo -> bar}")
      question.style.should eql(:matching)
      question.answer[0].correct.class.should eql(String)
      question.answer[0].correct.should eql("bar")
    end
    
    it "should return a style of matching when correct contains a symbols ->" do
      question = Gipper::Question.parse("Foo{=:) -> smiley}")
      question.style.should eql(:matching)
      question.answer[0].correct.class.should eql(String)
      question.answer[0].correct.should eql("smiley")
      question.answer[0].text.should eql(":)")
    end
    
    it "should return missing word when question_post is present" do
      question = Gipper::Question.new "foo {=bar} cheese."
      question.text.should eql("foo")
      question.text_post.should eql("cheese.")
      question.style.should eql(:missing_word)
      question.answer[0].correct.should eql(:true)
      question.answer[0].text.should eql("bar")
    end
  end
end
