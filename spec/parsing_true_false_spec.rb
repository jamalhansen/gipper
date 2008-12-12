require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::TrueFalseAnswerParser do
  
  before do
    @parser = Gipper::TrueFalseAnswerParser.new
  end
  
  it "should return a hash with 2 elements" do
    output = @parser.parse("T")
    output.length.should eql(2)
  end
  
  it "should return a style symbol of true_false" do
    output = @parser.parse("T")
    output[:style].should eql(:true_false)
  end
  
  it "should be tolerant of input errors" do
    output = @parser.parse(" T ")
    output[:answer].should eql(true)
    
    output = @parser.parse("TrUE ")
    output[:answer].should eql(true)
    
    output = @parser.parse(" true")
    output[:answer].should eql(true)
    
    output = @parser.parse(" t ")
    output[:answer].should eql(true)
    
    output = @parser.parse("F ")
    output[:answer].should eql(false)
    
    output = @parser.parse("  false ")
    output[:answer].should eql(false)
    
    output = @parser.parse(" faLse")
    output[:answer].should eql(false)
    
    output = @parser.parse(" f ")
    output[:answer].should eql(false)
  end
  
end
