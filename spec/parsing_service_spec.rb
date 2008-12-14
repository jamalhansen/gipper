require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::ParsingService do
  
  before(:each) do
    @parser = Gipper::ParsingService.new
    @single_question = "This is a really lame question"
    @single_answer = "{T}"
  end

  describe "(when passed an empty string)" do
    it "should return an empty array" do
      @parser.parse("").should eql([])
    end
  end
  
  describe "(when passed a single question without comments or title)" do
    
    before(:each) do
      @single_question = "This is a really lame question."
      @single_answer = "{T}"
      single_input = @single_question + @single_answer
      
      @output = @parser.parse(single_input)
    end
  
    it "should return an array with a single element" do
      @output.length.should eql(1)
    end
    
    it "should return the question" do
      @output[0][:question].should eql(@single_question)
    end
    
    it "should return the answer" do
      @output[0][:answer][0][:correct].should eql(:true)
    end
    
    it "should return the style" do
      @output[0][:answer].style.should eql(:true_false)
    end
  end
  
  describe "(when passed a single question with title but without comments)" do
    
    before(:each) do
      @single_title = "SuperTitle"
      @single_question = "Titles are bad."
      @single_answer = "{F}"
      single_input = "::#{@single_title}::#{@single_question}#{@single_answer}"
      
      @output = @parser.parse(single_input)
    end
  
    it "should return an array with a single element" do
      @output.length.should eql(1)
    end
    
    it "should return the question" do
      @output[0][:question].should eql(@single_question)
    end
    
    it "should return the answer" do
      @output[0][:answer][0][:correct].should eql(:false)
    end
    
    it "should return the style" do
      @output[0][:answer].style.should eql(:true_false)
    end
    
    it "should return the title" do
      @output[0][:title].should eql(@single_title)
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
      
      multiple_input = "#{true_false_question(@t1, @q1, @a1)}\r\n\r\n#{true_false_question(@t2, @q2, @a2)}\r\n\r\n#{true_false_question(@t3, @q3, @a3)}"
      @output = @parser.parse(multiple_input)
    end
  
    it "should return an array with a 3 elements" do
      @output.length.should eql(3)
    end
    
    it "should return the first title" do
     @output[0][:title].should eql(@t1)
    end
    
    it "should return the first question" do
      @output[0][:question].should eql(@q1)
    end
    
    it "should return the first answer" do
      @output[0][:answer][0][:correct].should eql(:true)
    end
    
    it "should return the first style" do
      @output[0][:answer].style.should eql(:true_false)
    end
    
    it "should return the second title" do
      @output[1][:title].should be(nil)
    end
    
    it "should return the second question" do
      @output[1][:question].should eql(@q2)
    end
    
    it "should return the second answer" do
      @output[1][:answer][0][:correct].should eql(:true)
    end
    
    it "should return the second style" do
     @output[1][:answer].style.should eql(:true_false)
    end
    
    it "should return the third title" do
      @output[2][:title].should eql(@t3)
    end
    
    it "should return the first question" do
      @output[2][:question].should eql(@q3)
    end
    
    it "should return the first answer" do
      @output[2][:answer][0][:correct].should eql(:true)
    end
    
    it "should return the first style" do
      @output[2][:answer].style.should eql(:true_false)
    end
  end
end
