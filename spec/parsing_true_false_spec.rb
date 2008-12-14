require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::AnswerParser do
  
  before do
    @parser = Gipper::AnswerParser.new
  end
  
  it "should return an Answer with 1 elements" do
    output = @parser.parse("T")
    output.length.should eql(1)
  end
  
  it "should return a style symbol of true_false" do
    output = @parser.parse("T")
    output.style.should eql(:true_false)
  end
  
  it "should be tolerant of input errors" do
    output = @parser.parse(" T ")
    output[0][:correct].should eql(:true)
    
    output = @parser.parse("TrUE ")
    output[0][:correct].should eql(:true)
    
    output = @parser.parse(" true")
    output[0][:correct].should eql(:true)
    
    output = @parser.parse(" t ")
    output[0][:correct].should eql(:true)
    
    output = @parser.parse("F ")
    output[0][:correct].should eql(:false)
    
    output = @parser.parse("  false ")
    output[0][:correct].should eql(:false)
    
    output = @parser.parse(" faLse")
    output[0][:correct].should eql(:false)
    
    output = @parser.parse(" f ")
    output[0][:correct].should eql(:false)
  end
  
end
