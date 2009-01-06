require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Answer do

  it "should accept a single answer without equals as the correct and only answer" do
    output = Gipper::Answer.parse("5" )
    output.correct.should eql(true)
    output.text.should eql("5")
  end
  
  it "should handle decimals for numerical answers" do
    output = Gipper::Answer.parse("5.6765", :numerical )
    output.correct.should eql(5.6765)
    output.weight.should eql(100)
    output.range.should eql(0)
  end
  
  it "should handle alternate range format for numerical answers" do
    output = Gipper::Answer.parse("5.1..5.9", :numerical )
    output.correct.should eql(5.5)
    output.weight.should eql(100)
    (output.range * 10).to_i.should eql 4

    output = Gipper::Answer.parse("5.6765..5.6766", :numerical )
    output.correct.should eql(5.67655)
    output.weight.should eql(100)
    (output.range * 100000).round.should eql(5)
  end
  
  describe "parsing true false questions" do
    it "should be tolerant of input variance" do
      output = Gipper::Answer.parse(" T" )
      output.correct.should eql(true)
      
      output = Gipper::Answer.parse("TrUE ")
      output.correct.should eql(true)
      
      output = Gipper::Answer.parse(" true")
      output.correct.should eql(true)
      
      output = Gipper::Answer.parse(" t ")
      output.correct.should eql(true)
      
      output = Gipper::Answer.parse("F ")
      output.correct.should eql(false)
      
      output = Gipper::Answer.parse("  false ")
      output.correct.should eql(false)
      
      output = Gipper::Answer.parse(" faLse")
      output.correct.should eql(false)
      
      output = Gipper::Answer.parse(" f ")
      output.correct.should eql(false)
    end
  end
end
  
