require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::MultipleChoiceAnswerParser do
  
  before do
    @parser = Gipper::MultipleChoiceAnswerParser.new
  end
  
  it "should parse a multiple choice answer" do
    output = @parser.parse("=Travel to the moon ~play tennis ~eat apples ~play fable 2 ~code in Assembly ")
    output.length.should eql(2)
    output.has_key?(:answers).should eql(true)
    output[:style].should eql(:multiple_choice)
    output[:answers][0].text.should eql("Travel to the moon")
    output[:answers][0].correct.should eql(:true)
    output[:answers][1].correct.should eql(:false)
    output[:answers][1].text.should eql("play tennis")
    output[:answers][2].correct.should eql(:false)
    output[:answers][2].text.should eql("eat apples")
    output[:answers][3].correct.should eql(:false)
    output[:answers][3].text.should eql("play fable 2")
    output[:answers][4].correct.should eql(:false)
    output[:answers][4].text.should eql("code in Assembly")
  end
  
  it "should be tolerant of input variance" do
    output = @parser.parse("  ~ %%%%%%% ~ UUUUUUUUU ~@@%^&* ~ 232323= 2345       ")
    output.length.should eql(2)
    output.has_key?(:answers).should eql(true)
    output[:style].should eql(:multiple_choice)
    output[:answers][0].text.should eql("%%%%%%%")
    output[:answers][0].correct.should eql(:false)
    output[:answers][1].correct.should eql(:false)
    output[:answers][1].text.should eql("UUUUUUUUU")
    output[:answers][2].correct.should eql(:false)
    output[:answers][2].text.should eql("@@%^&*")
    output[:answers][3].correct.should eql(:false)
    output[:answers][3].text.should eql("232323")
    output[:answers][4].correct.should eql(:true)
    output[:answers][4].text.should eql("2345")
  end
  
end
