
Given /^a GIFT file of short answer questions$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. fixtures short_answer.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then /^contains the correct short answer questions$/ do
  @questions.length.should be(3)
  
  #//File of short answer questions
  #::Intro question about coffee::
  #Coffee is made from {=ground coffee beans and water =burnt beans = the nectar of the gods}
  @questions[0].style.should eql(:short_answer)
  @questions[0].text.should eql("Coffee is made from")
  @questions[0].title.should eql("Intro question about coffee")
  @questions[0].answer.length.should eql(3)
  @questions[0].answer[0].correct.should eql(true)
  @questions[0].answer[0].text.should eql("ground coffee beans and water")
  @questions[0].answer[1].correct.should eql(true)
  @questions[0].answer[1].text.should eql("burnt beans")
  @questions[0].answer[2].correct.should eql(true)
  @questions[0].answer[2].text.should eql("the nectar of the gods")
  
  #Coffee is best when{ = hot = cold}
  @questions[1].style.should eql(:short_answer)
  @questions[1].text.should eql("Coffee is best when")
  @questions[1].title.should eql(nil)
  @questions[1].answer.length.should eql(2)
  @questions[1].answer[0].correct.should eql(true)
  @questions[1].answer[0].text.should eql("hot")
  @questions[1].answer[1].correct.should eql(true)
  @questions[1].answer[1].text.should eql("cold")
  
  #The only way to spell coffee is:{=coffee}
  @questions[2].style.should eql(:short_answer)
  @questions[2].text.should eql("The only way to spell coffee is:")
  @questions[2].title.should eql(nil)
  @questions[2].answer.length.should eql(1)
  @questions[2].answer[0].correct.should eql(true)
  @questions[2].answer[0].text.should eql("coffee")
end
