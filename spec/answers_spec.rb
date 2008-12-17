require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Answers do

  it "should return a style of true_false when it has one answer of true and no text" do
    answers = Gipper::Answers.new("T")
    answers.style.should eql(:true_false)
  end
  
  it "should return a style of true_false when it has one answer of false and no text" do
    answers = Gipper::Answers.new("F")
    answers.style.should eql(:true_false)
  end
  
  it "should return a style of multiple choice when it has more than one answer and text and only one answer is true" do
    answers = Gipper::Answers.new("~foo =bar")
    answers.style.should eql(:multiple_choice)
  end
  
  it "should return a style of short answer when it has more than one answer and text and all answers are true" do
    answers = Gipper::Answers.new("=foo =bar")
    answers.style.should eql(:short_answer)
  end
  
  it "should return a style of short answer when it has one true answer and text" do
    answers = Gipper::Answers.new("=foo")
    answers.style.should eql(:short_answer)
  end
  
  it "should return a style of matching when correct contains a string ->" do
    answers = Gipper::Answers.new("=foo -> bar")
    answers.style.should eql(:matching)
    answers[0][:correct].class.should eql(String)
    answers[0][:correct].should eql("bar")
  end
  
  it "should return a style of matching when correct contains a symbols ->" do
    answers = Gipper::Answers.new("=:) -> smiley")
    answers.style.should eql(:matching)
    answers[0][:correct].class.should eql(String)
    answers[0][:correct].should eql("smiley")
    answers[0][:text].should eql(":)")
  end
end
  
