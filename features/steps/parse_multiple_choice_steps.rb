
Given /^a GIFT file of multiple choice questions$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. fixtures multiple_choice.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then /^contains the correct multiple choice questions$/ do
  @questions.length.should be(6)


  #::Ninjas and the future::In the future, ninjas will be able to{= Travel to the moon ~play tennis ~eat apples ~play fable 2 ~code in Assembly }
  question = @questions[0]
  assert_equal 5, question.answer.length
  assert_question question, :style => :multiple_choice,
                            :text => "In the future, ninjas will be able to",
                            :title => "Ninjas and the future"

  assert_answer question.answer[0], :correct => true, :text => "Travel to the moon"
  assert_answer question.answer[1], :correct => false, :text => "play tennis"
  assert_answer question.answer[2], :correct => false, :text => "eat apples"
  assert_answer question.answer[3], :correct => false, :text => "play fable 2"
  assert_answer question.answer[4], :correct => false, :text => "code in Assembly"
  
  #// question: 2 name: Ninjas and you
  #::Ninjas and you::
  # If you see a ninja you should: {~offer them a crunchy frog =run ~attack them }
  question = @questions[1]
  assert_equal 3, question.answer.length
  assert_question question, :style => :multiple_choice,
                            :text => "If you see a ninja you should:",
                            :title => "Ninjas and you"

  assert_answer question.answer[0], :correct => false, :text => "offer them a crunchy frog"
  assert_answer question.answer[1], :correct => true, :text => "run"
  assert_answer question.answer[2], :correct => false, :text => "attack them"
  
  #Ninjas will only attack when {~provoked ~ upset ~off duty =none of the above}
  question = @questions[2]
  assert_equal 4, question.answer.length
  assert_question question, :style => :multiple_choice,
                            :text => "Ninjas will only attack when",
                            :title => nil

  assert_answer question.answer[0], :correct => false, :text => "provoked"
  assert_answer question.answer[1], :correct => false, :text => "upset"
  assert_answer question.answer[2], :correct => false, :text => "off duty"
  assert_answer question.answer[3], :correct => true, :text => "none of the above"
  
  #One way ninjas are like a snake is: {~Ninjas have scales ~Ninjas eat rodents =Ninjas can spit venom}
  question = @questions[3]
  assert_equal 3, question.answer.length
  assert_question question, :style => :multiple_choice,
                            :text => "One way ninjas are like a snake is:",
                            :title => nil

  assert_answer question.answer[0], :correct => false, :text => "Ninjas have scales"
  assert_answer question.answer[1], :correct => false, :text => "Ninjas eat rodents"
  assert_answer question.answer[2], :correct => true, :text => "Ninjas can spit venom"
  
  #::Supercomputing Ninjas
  #::Ninjas can recite the value of pi to how many digits?{
  #~10 
  ## do you even know what a ninja is?
  #~100 
  ## are you crazy?
  #~100,000 
  ## that is pitiful
  #=twice the US national debt
  ## if not more!
  #}
  question = @questions[4]
  assert_equal 4, question.answer.length
  assert_question question, :style => :multiple_choice,
                            :text => "Ninjas can recite the value of pi to how many digits?",
                            :title => "Supercomputing Ninjas"

  assert_answer question.answer[0], :correct => false, :text => "10", :comment => "do you even know what a ninja is?"
  assert_answer question.answer[1], :correct => false, :text => "100", :comment => "are you crazy?"
  assert_answer question.answer[2], :correct => false, :text => "100,000", :comment => "that is pitiful"
  assert_answer question.answer[3], :correct => true, :text => "twice the US national debt", :comment => "if not more!"
    
  #// Ninjas can be commented on
  #::Are you a Ninja?:: 
  #When confronted by a zombie army of terracotta kung-fu masters, you would: {
  #~ cry
  ## not even baby ninjas would do that
  #~ try to fight
  ## fight or fight not, there is no try.
  #= slay them all with a single strike before they even saw you.
  ## You are Ninja!
  #~ run away
  ## You would make a poor ninja.
  #}
  question = @questions[5]
  assert_equal 4, question.answer.length
  assert_question question, :style => :multiple_choice,
                            :text => "When confronted by a zombie army of terracotta kung-fu masters, you would:",
                            :title => "Are you a Ninja?"

  assert_answer question.answer[0], :correct => false, :text => "cry", :comment => "not even baby ninjas would do that"
  assert_answer question.answer[1], :correct => false, :text => "try to fight", :comment => "fight or fight not, there is no try."
  assert_answer question.answer[2], :correct => true, :text => "slay them all with a single strike before they even saw you.", :comment => "You are Ninja!"
  assert_answer question.answer[3], :correct => false, :text => "run away", :comment => "You would make a poor ninja."

end

