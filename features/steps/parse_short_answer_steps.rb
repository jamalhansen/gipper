
Given(/^a GIFT file of short answer questions$/) do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. fixtures short_answer.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then(/^contains the correct short answer questions$/) do
  @questions.length.should be(3)
  
  #//File of short answer questions
  #::Intro question about coffee::
  #Coffee is made from {=ground coffee beans and water =burnt beans = the nectar of the gods}
  question = @questions[0]
  assert_equal 3, question.answer.length
  assert_question question, :style => :short_answer,
                            :text => "Coffee is made from",
                            :title => "Intro question about coffee"

  assert_answer question.answer[0], :correct => true, :text => "ground coffee beans and water"
  assert_answer question.answer[1], :correct => true, :text => "burnt beans"
  assert_answer question.answer[2], :correct => true, :text => "the nectar of the gods"
  
  #Coffee is best when{ = hot = cold}
  question = @questions[1]
  assert_equal 2,  question.answer.length
  assert_question question, :style => :short_answer,
                            :text => "Coffee is best when",
                            :title => nil

  assert_answer question.answer[0], :correct => true, :text => "hot"
  assert_answer question.answer[1], :correct => true, :text => "cold"
  
  #The only way to spell coffee is:{=coffee}
  question = @questions[2]
  assert_equal 1,  question.answer.length
  assert_question question, :style => :short_answer,
                            :text => "The only way to spell coffee is:",
                            :title => nil

  assert_answer question.answer[0], :correct => true, :text => "coffee"
end
