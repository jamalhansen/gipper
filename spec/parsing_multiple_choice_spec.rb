require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::AnswerParser do
  
  before do
    @parser = Gipper::AnswerParser.new
  end
  
  it "should parse a multiple choice answer" do
    output = @parser.parse("=Travel to the moon ~play tennis ~eat apples ~play fable 2 ~code in Assembly ")
    output.length.should eql(5)
    output.style.should eql(:multiple_choice)
    output[0][:text].should eql("Travel to the moon")
    output[0][:correct].should eql(:true)
    output[1][:correct].should eql(:false)
    output[1][:text].should eql("play tennis")
    output[2][:correct].should eql(:false)
    output[2][:text].should eql("eat apples")
    output[3][:correct].should eql(:false)
    output[3][:text].should eql("play fable 2")
    output[4][:correct].should eql(:false)
    output[4][:text].should eql("code in Assembly")
  end
  
  it "should be tolerant of input variance" do
    output = @parser.parse("  ~ %%%%%%% ~ UUUUUUUUU ~@@%^&* ~ 232323= 2345       ")
    output.length.should eql(5)
    output.style.should eql(:multiple_choice)
    output[0][:text].should eql("%%%%%%%")
    output[0][:correct].should eql(:false)
    output[1][:correct].should eql(:false)
    output[1][:text].should eql("UUUUUUUUU")
    output[2][:correct].should eql(:false)
    output[2][:text].should eql("@@%^&*")
    output[3][:correct].should eql(:false)
    output[3][:text].should eql("232323")
    output[4][:correct].should eql(:true)
    output[4][:text].should eql("2345")
  end
  
end
