require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Answers do

  describe "parsing true false questions" do
    it "should be tolerant of input variance" do
      output = Gipper::Answer.new(" T" )
      output.correct.should eql(:true)
      
      output = Gipper::Answer.new("TrUE ")
      output.correct.should eql(:true)
      
      output = Gipper::Answer.new(" true")
      output.correct.should eql(:true)
      
      output = Gipper::Answer.new(" t ")
      output.correct.should eql(:true)
      
      output = Gipper::Answer.new("F ")
      output.correct.should eql(:false)
      
      output = Gipper::Answer.new("  false ")
      output.correct.should eql(:false)
      
      output = Gipper::Answer.new(" faLse")
      output.correct.should eql(:false)
      
      output = Gipper::Answer.new(" f ")
      output.correct.should eql(:false)
    end
  end
end
  
