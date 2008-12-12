require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::ParsingService do
  
  it "should be tolerant of input errors" do
    parser = Gipper::ParsingService.new
    output = parser.parse("dsjlds ldksjdlskjdljdsl        { T }")
    output[0][:answer].should eql(true)
    
    output = parser.parse("dsjlds ldksjdlskjdljdsl        {TrUE }")
    output[0][:answer].should eql(true)
    
    output = parser.parse("dsjlds ldksjdlskjdljdsl        { true}")
    output[0][:answer].should eql(true)
    
    output = parser.parse("dsjlds ldksjdlskjdljds{ t }")
    output[0][:answer].should eql(true)
    
    output = parser.parse("dsjlds ldksjdlskjdljdsl        {F }")
    output[0][:answer].should eql(false)
    
    output = parser.parse("dsjlds ldksjdlskjdljdsl        {  false }")
    output[0][:answer].should eql(false)
    
    output = parser.parse("dsjlds ldksjdlskjdljdsl        { faLse}")
    output[0][:answer].should eql(false)
    
    output = parser.parse("dsjlds ldksjdlskjdljds{ f }")
    output[0][:answer].should eql(false)
    
  end
  
end
