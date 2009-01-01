require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Answer do

  it "should accept a single answer without equals as the correct and only answer" do
    output = Gipper::Answer.parse("5" )
    output.correct.should eql("5")
  end
  
  describe "parsing true false questions" do
    it "should be tolerant of input variance" do
      output = Gipper::Answer.parse(" T" )
      output.correct.should eql(:true)
      
      output = Gipper::Answer.parse("TrUE ")
      output.correct.should eql(:true)
      
      output = Gipper::Answer.parse(" true")
      output.correct.should eql(:true)
      
      output = Gipper::Answer.parse(" t ")
      output.correct.should eql(:true)
      
      output = Gipper::Answer.parse("F ")
      output.correct.should eql(:false)
      
      output = Gipper::Answer.parse("  false ")
      output.correct.should eql(:false)
      
      output = Gipper::Answer.parse(" faLse")
      output.correct.should eql(:false)
      
      output = Gipper::Answer.parse(" f ")
      output.correct.should eql(:false)
    end
  end
end
  
