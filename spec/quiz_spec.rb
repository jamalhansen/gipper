require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Quiz do
  
  before(:each) do
    @single_question = "This is a really lame question"
    @single_answer = "{T}"
  end

  it "should remove commented lines before parsing" do
    file = File.open(File.join(File.dirname(__FILE__), *%w[files begins_with_comment.txt]))
    Gipper::Quiz.new.iterate_through file.read do |q|
      q.should eql("1=1{T}")
    end
  end
  
  describe "(when passed an empty string)" do
    it "should return an empty array" do
      quiz = Gipper::Quiz.parse("")
      quiz.should eql([])
    end
  end
  
  describe "(when passed more than one question)" do
    
    before(:each) do
      @q = []
      @q << true_false_question("Weather Patterns in the Pacific Northwest", "Seattle is rainy.", "{T}")
      @q << true_false_question("", "Seattle has lots of water.", "{T}")
      @q << true_false_question("Accessories in the Pacific Northwest", "People in Seattle use umbrellas:", "{T}")

      @multiple_input = "//opening comment\r\n//another comment\r\n\r\n\r\n#{@q[0]}\r\n//this is a \r\n//couple rows of comments\r\n\r\n#{@q[1]}\r\n\r\n#{@q[2]}"
    end
  
    it "should return an array with a 3 elements" do
      Gipper::Quiz.new.iterate_through(@multiple_input) do |q|
        @q.include?(q).should eql(true)
      end
    end
  end
end
