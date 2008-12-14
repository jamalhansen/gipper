require File.join(File.dirname(__FILE__), *%w[.. .. spec spec_helper.rb])

Given(/^a GIFT file of true or false questions$/) do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. .. spec files true_or_false.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then(/^contains the correct true or false questions$/)do  
  @questions.length.should be(6)
  
  #::TrueStatement about monkeys::Monkeys like to fly like ninjas.{T}
  @questions[0][:answer].style.should eql(:true_false)
  @questions[0][:question].should eql("Monkeys like to fly like ninjas.")
  @questions[0][:title].should eql("TrueStatement about monkeys")
  @questions[0][:answer][0][:correct].should eql(:true)
  
  #// question: 0 name: TrueStatement
  #::A Second TrueStatement about monkeys::
  #Monkeys roam in packs with swords.{True}
  @questions[1][:answer].style.should eql(:true_false)
  @questions[1][:question].should eql("Monkeys roam in packs with swords.")
  @questions[1][:title].should eql("A Second TrueStatement about monkeys")
  @questions[1][:answer][0][:correct].should eql(:true)
  
  #Monkeys will jump from buildings without fear. {T}
  @questions[2][:answer].style.should eql(:true_false)
  @questions[2][:question].should eql("Monkeys will jump from buildings without fear.")
  @questions[2][:title].should eql(nil)
  @questions[2][:answer][0][:correct].should eql(:true)
  
  #Monkeys have a formal system of government{False}
  @questions[3][:answer].style.should eql(:true_false)
  @questions[3][:question].should eql("Monkeys have a formal system of government")
  @questions[3][:title].should eql(nil)
  @questions[3][:answer][0][:correct].should eql(:false)

  #::A Second FalseStatement about monkeys
  #::Monkeys wear suits and sit around in corporate offices.{False}
  @questions[4][:answer].style.should eql(:true_false)
  @questions[4][:question].should eql("Monkeys wear suits and sit around in corporate offices.")
  @questions[4][:title].should eql("A Second FalseStatement about monkeys")
  @questions[4][:answer][0][:correct].should eql(:false)
  
  #// question: 6 name: FalseStatement
  #::A Third FalseStatement about monkeys:: Monkeys can operate heavy machinery.{F}
  @questions[5][:answer].style.should eql(:true_false)
  @questions[5][:question].should eql("Monkeys can operate heavy machinery.")
  @questions[5][:title].should eql("A Third FalseStatement about monkeys")
  @questions[5][:answer][0][:correct].should eql(:false)
end
