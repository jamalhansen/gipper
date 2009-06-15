Given(/^a GIFT file of true or false questions$/) do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. fixtures true_or_false.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then(/^contains the correct true or false questions$/)do  
  @questions.length.should be(6)
  
  #:trueStatement about monkeys::Monkeys like to fly like ninjas.{T}
  question = @questions[0]
  assert_question question, :style => :true_false,
                            :text => "Monkeys like to fly like ninjas.",
                            :title => "TrueStatement about monkeys"

  assert_answer question.answer[0], :correct => true
  
  #// question: 0 name: TrueStatement
  #::A Second TrueStatement about monkeys::
  #Monkeys roam in packs with swords.{True}
  question = @questions[1]
  assert_question question, :style => :true_false,
                            :text => "Monkeys roam in packs with swords.",
                            :title => "A Second TrueStatement about monkeys"

  assert_answer question.answer[0], :correct => true
  
  #Monkeys will jump from buildings without fear. {T}
  question = @questions[2]
  assert_question question, :style => :true_false,
                            :text => "Monkeys will jump from buildings without fear.",
                            :title => nil

  assert_answer question.answer[0], :correct => true
  
  #Monkeys have a formal system of government{False}
  question = @questions[3]
  assert_question question, :style => :true_false,
                            :text => "Monkeys have a formal system of government",
                            :title => nil

  assert_answer question.answer[0], :correct => false

  #::A Second FalseStatement about monkeys
  #::Monkeys wear suits and sit around in corporate offices.{False}
  question = @questions[4]
  assert_question question, :style => :true_false,
                            :text => "Monkeys wear suits and sit around in corporate offices.",
                            :title => "A Second FalseStatement about monkeys"

  assert_answer question.answer[0], :correct => false
  
  #// question: 6 name: FalseStatement
  #::A Third FalseStatement about monkeys:: Monkeys can operate heavy machinery.{F}
  question = @questions[5]
  assert_question question, :style => :true_false,
                            :text => "Monkeys can operate heavy machinery.",
                            :title => "A Third FalseStatement about monkeys"

  assert_answer question.answer[0], :correct => false
end
