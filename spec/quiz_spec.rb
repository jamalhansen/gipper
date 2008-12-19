require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Quiz do
  
  before(:each) do
    @single_question = "This is a really lame question"
    @single_answer = "{T}"
  end

  describe "(when passed an empty string)" do
    it "should return an empty array" do
      quiz = Gipper::Quiz.parse("")
      quiz.should eql([])
    end
  end
  
  describe "(when passed a single question without comments or title)" do
    
    before(:each) do
      @single_question = "wubble."
      @single_answer = "{=:) -> smiley}"
      single_input = @single_question + @single_answer
      
      @quiz = Gipper::Quiz.parse(single_input)
    end
  
    it "should return an array with a single element" do
      @quiz.length.should eql(1)
    end
    
    it "should return the question" do
      @quiz[0].text.should eql("wubble.")
    end
    
    it "should return the answer" do
      @quiz[0].answer[0].correct.should eql("smiley")
    end
    
    it "should return the answer" do
      @quiz[0].answer[0].text.should eql(":)")
    end
    
    it "should return the style" do
      @quiz[0].style.should eql(:matching)
    end
  end
  
  describe "(when passed a single question with title but without comments)" do
    
    before(:each) do
      @single_title = "SuperTitle"
      @single_question = "Titles are bad."
      @single_answer = "{F}"
      single_input = "::#{@single_title}::#{@single_question}#{@single_answer}"
      
      @quiz = Gipper::Quiz.parse(single_input)
    end
  
    it "should return an array with a single element" do
      @quiz.length.should eql(1)
    end
    
    it "should return the question" do
      @quiz[0].text.should eql(@single_question)
    end
    
    it "should return the answer" do
      @quiz[0].answer[0].correct.should eql(:false)
    end
    
    it "should return the style" do
      @quiz[0].style.should eql(:true_false)
    end
    
    it "should return the title" do
      @quiz[0].title.should eql(@single_title)
    end
  end
  
  describe "when passed a question with escaped brackets" do
    it "should ignore the brackets" do
      @quiz = Gipper::Quiz.parse(' foo \{escaped bracketed text\}{T}')
      @quiz.length.should eql(1)
      @quiz[0].text.should eql("foo {escaped bracketed text}")
      @quiz[0].style.should eql(:true_false)
      @quiz[0].answer[0].correct.should eql(:true)
    end
    
    
    it "should handle all kinds of escaped stuff" do
      @quiz = Gipper::Quiz.parse(' my crazy \#\~\= question \{escaped bracketed text\}{=\=\#\~foo#hi-yah}')
      @quiz.length.should eql(1)
      @quiz[0].text.should eql("my crazy #~= question {escaped bracketed text}")
      @quiz[0].style.should eql(:short_answer)
      @quiz[0].answer[0].correct.should eql(:true)
      @quiz[0].answer[0].text.should eql('=#~foo')
      @quiz[0].answer[0].comment.should eql('hi-yah')
    end
  end
  
  describe "(when passed more than one question)" do
    
    before(:each) do
      @q1 = "Seattle is rainy."
      @a1 = "{T}"
      @t1 = "Weather Patterns in the Pacific Northwest"

      @q2 = "Seattle has lots of water."
      @a2 = "{T}"
      
      @q3 = "People in Seattle use umbrellas:"
      @a3 = "{T}"
      @t3 = "Accessories in the Pacific Northwest"

      multiple_input = "\r\n\r\n\\r\n#{true_false_question(@t1, @q1, @a1)}\r\n\\\\this is a \r\n\\\\couple rows of comments\r\n\r\n#{true_false_question(@t2, @q2, @a2)}\r\n\r\n#{true_false_question(@t3, @q3, @a3)}"
      @quiz = Gipper::Quiz.parse(multiple_input)
    end
  
    it "should return an array with a 3 elements" do
      @quiz.length.should eql(3)
    end
    
    it "should return the first title" do
     @quiz[0].title.should eql(@t1)
    end
    
    it "should return the first question" do
      @quiz[0].text.should eql(@q1)
    end
    
    it "should return the first answer" do
      @quiz[0].answer[0].correct.should eql(:true)
    end
    
    it "should return the first style" do
      @quiz[0].style.should eql(:true_false)
    end
    
    it "should return the second title" do
      @quiz[1].title.should be(nil)
    end
    
    it "should return the second question" do
      @quiz[1].text.should eql(@q2)
    end
    
    it "should return the second answer" do
      @quiz[1].answer[0].correct.should eql(:true)
    end
    
    it "should return the second style" do
     @quiz[1].style.should eql(:true_false)
    end
    
    it "should return the third title" do
      @quiz[2].title.should eql(@t3)
    end
    
    it "should return the first question" do
      @quiz[2].text.should eql(@q3)
    end
    
    it "should return the first answer" do
      @quiz[2].answer[0].correct.should eql(:true)
    end
    
    it "should return the first style" do
      @quiz[2].style.should eql(:true_false)
    end
  end
  
  describe "when determining the answer style" do
    it "should return a style of true_false when it has one answer of true and no text" do
      quiz = Gipper::Quiz.parse("Foo{T}")
      quiz[0].style.should eql(:true_false)
    end
    
    it "should return a style of true_false when it has one answer of false and no text" do
      quiz = Gipper::Quiz.parse("Foo{F}")
      quiz[0].style.should eql(:true_false)
    end
    
    it "should return a style of multiple choice when it has more than one answer and text and only one answer is true" do
      quiz = Gipper::Quiz.parse("Foo{~foo =bar}")
      quiz[0].style.should eql(:multiple_choice)
    end
    
    it "should return a style of short answer when it has more than one answer and text and all answers are true" do
      quiz = Gipper::Quiz.parse("Foo{=foo =bar}")
      quiz[0].style.should eql(:short_answer)
    end
    
    it "should return a style of short answer when it has one true answer and text" do
      quiz = Gipper::Quiz.parse("Foo{=foo}")
      quiz[0].style.should eql(:short_answer)
    end
    
    it "should return a style of matching when correct contains a string ->" do
      quiz = Gipper::Quiz.parse("Foo{=foo -> bar}")
      quiz[0].style.should eql(:matching)
      quiz[0].answer[0].correct.class.should eql(String)
      quiz[0].answer[0].correct.should eql("bar")
    end
    
    it "should return a style of matching when correct contains a symbols ->" do
      quiz = Gipper::Quiz.parse("Foo{=:) -> smiley}")
      quiz[0].style.should eql(:matching)
      quiz[0].answer[0].correct.class.should eql(String)
      quiz[0].answer[0].correct.should eql("smiley")
      quiz[0].answer[0].text.should eql(":)")
    end
    
    it "should return missing word when question_post is present" do
      quiz = Gipper::Quiz.new "foo {=bar} cheese."
      quiz[0].text.should eql("foo")
      quiz[0].text_post.should eql("cheese.")
      quiz[0].style.should eql(:missing_word)
      quiz[0].answer[0].correct.should eql(:true)
      quiz[0].answer[0].text.should eql("bar")
    end
  end
end
