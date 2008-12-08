
Given /^a GIFT file of multiple choice questions$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. .. spec files multiple_choice.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then /^contains the correct multiple choice questions$/ do
  @questions.length.should be 6

  #::Ninjas and the future::In the future, ninjas will be able to{= Travel to the moon ~play tennis ~eat apples ~play fable 2 ~code in Assembly }
  @questions[0][:style].should eql(:multiple_choice)
  @questions[0][:question].should eql("In the future, ninjas will be able to")
  @questions[0][:title].should eql("Ninjas and the future")
  @questions[0][:answers][0].correct.should eql(:true)
  @questions[0][:answers][0].text.should eql("Travel to the moon")
  @questions[0][:answers][1].correct.should eql(:false)
  @questions[0][:answers][1].text.should eql("play tennis")
  @questions[0][:answers][2].correct.should eql(:false)
  @questions[0][:answers][2].text.should eql("eat apples")
  @questions[0][:answers][3].correct.should eql(:false)
  @questions[0][:answers][3].text.should eql("play fable 2")
  @questions[0][:answers][4].correct.should eql(:false)
  @questions[0][:answers][4].text.should eql("code in Assembly")
  
  #// question: 2 name: Ninjas and you
  #::Ninjas and you::
  # If you see a ninja you should: {~offer them a crunchy frog =run ~attack them }
  @questions[1][:style].should eql(:multiple_choice)
  @questions[1][:question].should eql("If you see a ninja you should:")
  @questions[1][:title].should eql("Ninjas and you")
  @questions[1][:answers][0].correct.should eql(:false)
  @questions[1][:answers][0].text.should eql("offer them a crunchy frog")
  @questions[1][:answers][1].correct.should eql(:true)
  @questions[1][:answers][1].text.should eql("run")
  @questions[1][:answers][2].correct.should eql(:false)
  @questions[1][:answers][2].text.should eql("attack them")
  
  #Ninjas will only attack when {~provoked ~ upset ~off duty =none of the above}
  @questions[2][:style].should eql(:multiple_choice)
  @questions[2][:question].should eql("Ninjas will only attack when")
  @questions[2][:title].should eql(nil)
  @questions[2][:answers][0].correct.should eql(:false)
  @questions[2][:answers][0].text.should eql("provoked")
  @questions[2][:answers][1].correct.should eql(:false)
  @questions[2][:answers][1].text.should eql("upset")
  @questions[2][:answers][2].correct.should eql(:false)
  @questions[2][:answers][2].text.should eql("off_duty")
  @questions[2][:answers][3].correct.should eql(:true)
  @questions[2][:answers][3].text.should eql("none of the above")
  
  #One way ninjas are like a snake is: {~Ninjas have scales ~Ninjas eat rodents =Ninjas can spit venom}
  @questions[3][:style].should eql(:multiple_choice)
  @questions[3][:question].should eql("One way ninjas are like a snake is:")
  @questions[3][:title].should eql(nil)
  @questions[3][:answers][0].correct.should eql(:false)
  @questions[3][:answers][0].text.should eql("Ninjas have scales")
  @questions[3][:answers][1].correct.should eql(:false)
  @questions[3][:answers][1].text.should eql("Ninjas eat rodents")
  @questions[3][:answers][2].correct.should eql(:true)
  @questions[3][:answers][2].text.should eql("Ninjas can spit venom")
  
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
  @questions[4][:style].should eql(:multiple_choice)
  @questions[4][:question].should eql("Ninjas can recite the value of pi to how many digits?")
  @questions[4][:title].should eql("Supercomputing Ninjas")
  @questions[4][:answers][0].correct.should eql(:false)
  @questions[4][:answers][0].text.should eql("10")
  @questions[4][:answers][0].comment.should eql("do you even know what a ninja is?")
  @questions[4][:answers][1].correct.should eql(:false)
  @questions[4][:answers][1].text.should eql("100")
  @questions[4][:answers][1].comment.should eql("are you crazy?")
  @questions[4][:answers][2].correct.should eql(:false)
  @questions[4][:answers][2].text.should eql("100,000")
  @questions[4][:answers][2].comment.should eql("that is pitiful")
  @questions[4][:answers][3].correct.should eql(:true)
  @questions[4][:answers][3].text.should eql("twice the US national debt")
  @questions[4][:answers][3].comment.should eql("if not more!")
    
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
  @questions[5][:style].should eql(:multiple_choice)
  @questions[5][:question].should eql("When confronted by a zombie army of terracotta kung-fu masters, you would:")
  @questions[5][:title].should eql("Are you a Ninja?")
  @questions[5][:answers][0].correct.should eql(:false)
  @questions[5][:answers][0].text.should eql("cry")
  @questions[5][:answers][0].comment.should eql("not even baby ninjas would do that")
  @questions[5][:answers][1].correct.should eql(:false)
  @questions[5][:answers][1].text.should eql("try to fight")
  @questions[5][:answers][1].comment.should eql("fight or fight not, there is no try.")
  @questions[5][:answers][2].correct.should eql(:false)
  @questions[5][:answers][2].text.should eql("slay them all with a single strike before they even saw you.")
  @questions[5][:answers][2].comment.should eql("You are Ninja!")
  @questions[5][:answers][3].correct.should eql(:true)
  @questions[5][:answers][3].text.should eql("run away")
  @questions[5][:answers][3].comment.should eql("You would make a poor ninja.")
end

