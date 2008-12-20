require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Quiz do
  
  before(:each) do
    @single_question = "This is a really lame question"
    @single_answer = "{T}"
  end

  it "should remove commented lines before parsing" do
    file = File.open(File.join(File.dirname(__FILE__), *%w[files begins_with_comment.txt]))
    quiz = Gipper::Quiz.parse(file.read)
    quiz.length.should eql(1)
    quiz[0].text.should eql("1=1")
    quiz[0].answer[0].correct.should eql(:true)
  end
  
  describe "(when passed an empty string)" do
    it "should return an empty array" do
      quiz = Gipper::Quiz.parse("")
      quiz.should eql([])
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

      multiple_input = "//opening comment\r\n//another comment\r\n\r\n\r\n#{true_false_question(@t1, @q1, @a1)}\r\n//this is a \r\n//couple rows of comments\r\n\r\n#{true_false_question(@t2, @q2, @a2)}\r\n\r\n#{true_false_question(@t3, @q3, @a3)}"
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
end
