require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Answers do

  describe "parsing true false questions" do
    it "should be tolerant of input errors" do
      output = Gipper::Answers.new(" T" )
      output[0].correct.should eql(:true)
      
      output = Gipper::Answers.new("TrUE ")
      output[0].correct.should eql(:true)
      
      output = Gipper::Answers.new(" true")
      output[0].correct.should eql(:true)
      
      output = Gipper::Answers.new(" t ")
      output[0].correct.should eql(:true)
      
      output = Gipper::Answers.new("F ")
      output[0].correct.should eql(:false)
      
      output = Gipper::Answers.new("  false ")
      output[0].correct.should eql(:false)
      
      output = Gipper::Answers.new(" faLse")
      output[0].correct.should eql(:false)
      
      output = Gipper::Answers.new(" f ")
      output[0].correct.should eql(:false)
    end
  end
  
  it "should identify matching questions and place the match into correct" do
    output = Gipper::Answers.new("=waffle -> cone =cheese -> cheddar")
    output.length.should eql(2)
    output[0].text.should eql("waffle")
    output[0].correct.should eql("cone")
    output[1].text.should eql("cheese")
    output[1].correct.should eql("cheddar")
  end
  
  it "should parse a multiple choice answer" do
    output = Gipper::Answers.new("=Travel to the moon ~play tennis ~eat apples ~play fable 2 ~code in Assembly ")
    output.length.should eql(5)
    output[0].text.should eql("Travel to the moon")
    output[0].correct.should eql(:true)
    output[1].correct.should eql(:false)
    output[1].text.should eql("play tennis")
    output[2].correct.should eql(:false)
    output[2].text.should eql("eat apples")
    output[3].correct.should eql(:false)
    output[3].text.should eql("play fable 2")
    output[4].correct.should eql(:false)
    output[4].text.should eql("code in Assembly")
  end
  
  it "should be tolerant of input variance" do
    output = Gipper::Answers.new("  ~ %%%%%%% ~ UUUUUUUUU ~@@%^&* ~ 232323= 2345       ")
    output.length.should eql(5)
    output[0].text.should eql("%%%%%%%")
    output[0].correct.should eql(:false)
    output[1].correct.should eql(:false)
    output[1].text.should eql("UUUUUUUUU")
    output[2].correct.should eql(:false)
    output[2].text.should eql("@@%^&*")
    output[3].correct.should eql(:false)
    output[3].text.should eql("232323")
    output[4].correct.should eql(:true)
    output[4].text.should eql("2345")
  end
  
  it "should get answer conmments" do
    output = Gipper::Answers.new("  ~ %%%%%%%#foo = UUUUUUUUU #bar")
    output.length.should eql(2)
    output[0].text.should eql("%%%%%%%")
    output[0].correct.should eql(:false)
    output[0].comment.should eql("foo")
    output[1].correct.should eql(:true)
    output[1].text.should eql("UUUUUUUUU")
    output[1].comment.should eql("bar")
  end
  
  it "should get answer conmments when preceeded by a new line" do
    output = Gipper::Answers.new("  ~ Oompa\r\n#kun\r\n = Loompa\r\n #pyakun")
    output.length.should eql(2)
    output[0].text.should eql("Oompa")
    output[0].correct.should eql(:false)
    output[0].comment.should eql("kun")
    output[1].correct.should eql(:true)
    output[1].text.should eql("Loompa")
    output[1].comment.should eql("pyakun")
  end
  
  # If you want to use curly braces, { or }, or equal sign, =, 
  # or # or ~ in a GIFT file (for example in a math question including 
  # TeX expressions) you must "escape" them by preceding them with a \ 
  # directly in front of each { or } or =. 
  it "should ignore escaped characters" do
    output = Gipper::Answers.new('~ \{\}\~\=\#foo =\{\}\~\=\#bar')
    output.length.should eql(2)
    output[0].text.should eql("{}~=#foo")
    output[0].correct.should eql(:false)
    output[0].comment.should eql(nil)
    output[1].text.should eql("{}~=#bar")
    output[1].correct.should eql(:true)
    output[1].comment.should eql(nil)
  end
  
  it "should return just a question mark for question_post when question_post is just a question mark" do
    quiz = Gipper::Quiz.new 'You say that, "money is the root of all evil", I ask you "what is the root of all {~honey ~bunnies =money}?"'
    quiz[0].text.should eql('You say that, "money is the root of all evil", I ask you "what is the root of all')
    quiz[0].text_post.should eql('?"')
    
    answers = quiz[0].answer
    answers[0].correct.should eql(:false)
    answers[0].text.should eql("honey")
    answers[1].correct.should eql(:false)
    answers[1].text.should eql("bunnies")
    answers[2].correct.should eql(:true)
    answers[2].text.should eql("money")
  end
  
  it "should understand numerical answer format" do
    answers = Gipper::Answers.new("#2000:3")
    answers.length.should eql(1)
    answers[0].correct.should eql(2000)
    answers[0].range.should eql(3)
    answers[0].weight.should eql(100)
    answers[0].comment.should eql(nil)
  end
  
  it "should understand multiple numerical answer format" do
    answers = Gipper::Answers.new("# =2000:0 #Whoopdee do! =%50%2000:3 #Yippers")
    answers.length.should eql(2)
    answers[0].correct.should eql(2000)
    answers[0].range.should eql(0)
    answers[0].weight.should eql(100)
    answers[0].comment.should eql("Whoopdee do!")
    answers[1].correct.should eql(2000)
    answers[1].range.should eql(3)
    answers[1].weight.should eql(50)
    answers[1].comment.should eql("Yippers")
  end
end
  
