require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::AnswerParser do
  
  before do
    @answers = Gipper::Answers.new
  end
  
  
  it "should return a style of true_false when it has one answer of true and no text" do
    @answers[0] = {}
    @answers[0][:correct] = :true
    
    @answers.style.should eql(:true_false)
  end
  
  it "should return a style of true_false when it has one answer of false and no text" do
    @answers[0] = {}
    @answers[0][:correct] = :false
    
    @answers.style.should eql(:true_false)
  end
  
  it "should return a style of multiple choice when it has more than one answer and text and only one answer is true" do
    @answers[0] = { :text => "foo", :correct => :false }
    @answers[1] = { :text => "bar", :correct => :true }
    
    @answers.style.should eql(:multiple_choice)
  end
  
  it "should return a style of short answer when it has more than one answer and text and all answers are true" do
    @answers[0] = { :text => "foo", :correct => :true }
    @answers[1] = { :text => "bar", :correct => :true }
    
    @answers.style.should eql(:short_answer)
  end
  
  it "should return a style of short answer when it has one true answer and text" do
    @answers[0] = { :text => "foo", :correct => :true }
    
    @answers.style.should eql(:short_answer)
  end
end
  
