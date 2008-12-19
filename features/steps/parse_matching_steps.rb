
Given /^a GIFT file of matching questions$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. .. spec files matching.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then /^contains the correct matching questions$/ do
  #//My file of matching questions about emoticons
  #::Intro to matching questions
  #::Match the emoticon to the correct emotion:{
  #=:) -> smiling
  #=:D -> crazy happy
  #=\(^_^)/ -> yay!
  #=:( -> sad
  #}
  @questions.length.should be(1)
  
  @questions[0].style.should eql(:matching)
  @questions[0].text.should eql("Match the emoticon to the correct emotion:")
  @questions[0].title.should eql("Intro to matching questions")
  @questions[0].answer.length.should eql(4)
  @questions[0].answer[0].text.should eql(":)")
  @questions[0].answer[0].correct.should eql("smiling")
  @questions[0].answer[1].text.should eql(":D")
  @questions[0].answer[1].correct.should eql("crazy happy")
  @questions[0].answer[2].text.should eql('\(^_^)/')
  @questions[0].answer[2].correct.should eql("yay!")
  @questions[0].answer[3].text.should eql(":(")
  @questions[0].answer[3].correct.should eql("sad")
end

