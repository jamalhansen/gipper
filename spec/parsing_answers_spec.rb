require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::AnswerParser do

  describe "parsing true false questions" do
    it "should be tolerant of input errors" do
      output = Gipper::Answers.new(" T ")
      output[0][:correct].should eql(:true)
      
      output = Gipper::Answers.new("TrUE ")
      output[0][:correct].should eql(:true)
      
      output = Gipper::Answers.new(" true")
      output[0][:correct].should eql(:true)
      
      output = Gipper::Answers.new(" t ")
      output[0][:correct].should eql(:true)
      
      output = Gipper::Answers.new("F ")
      output[0][:correct].should eql(:false)
      
      output = Gipper::Answers.new("  false ")
      output[0][:correct].should eql(:false)
      
      output = Gipper::Answers.new(" faLse")
      output[0][:correct].should eql(:false)
      
      output = Gipper::Answers.new(" f ")
      output[0][:correct].should eql(:false)
    end
  end
  
  it "should identify matching questions and place the match into correct" do
    output = Gipper::Answers.new("=waffle -> cone =cheese -> cheddar")
    output.length.should eql(2)
    output.style.should eql(:matching)
    output[0][:text].should eql("waffle")
    output[0][:correct].should eql("cone")
    output[1][:text].should eql("cheese")
    output[1][:correct].should eql("cheddar")
  end
  
  it "should parse a multiple choice answer" do
    output = Gipper::Answers.new("=Travel to the moon ~play tennis ~eat apples ~play fable 2 ~code in Assembly ")
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
    output = Gipper::Answers.new("  ~ %%%%%%% ~ UUUUUUUUU ~@@%^&* ~ 232323= 2345       ")
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
  
  it "should get answer conmments" do
    output = Gipper::Answers.new("  ~ %%%%%%%#foo = UUUUUUUUU #bar")
    output.length.should eql(2)
    output.style.should eql(:multiple_choice)
    output[0][:text].should eql("%%%%%%%")
    output[0][:correct].should eql(:false)
    output[0][:comment].should eql("foo")
    output[1][:correct].should eql(:true)
    output[1][:text].should eql("UUUUUUUUU")
    output[1][:comment].should eql("bar")
  end
  
  it "should get answer conmments when preceeded by a new line" do
    output = Gipper::Answers.new("  ~ Oompa\r\n#kun\r\n = Loompa\r\n #pyakun")
    output.length.should eql(2)
    output.style.should eql(:multiple_choice)
    output[0][:text].should eql("Oompa")
    output[0][:correct].should eql(:false)
    output[0][:comment].should eql("kun")
    output[1][:correct].should eql(:true)
    output[1][:text].should eql("Loompa")
    output[1][:comment].should eql("pyakun")
  end
  
  # If you want to use curly braces, { or }, or equal sign, =, 
  # or # or ~ in a GIFT file (for example in a math question including 
  # TeX expressions) you must "escape" them by preceding them with a \ 
  # directly in front of each { or } or =. 
  it "should ignore escaped characters" do
    output = Gipper::Answers.new('~ \{\}\~\=\#foo =\{\}\~\=\#bar')
    output.length.should eql(2)
    output.style.should eql(:multiple_choice)
    output[0][:text].should eql("{}~=#foo")
    output[0][:correct].should eql(:false)
    output[0][:comment].should eql(nil)
    output[1][:text].should eql("{}~=#bar")
    output[1][:correct].should eql(:true)
    output[1][:comment].should eql(nil)
  end
  
end
