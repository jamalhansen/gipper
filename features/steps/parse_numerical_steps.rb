Given /^a GIFT file of numerical questions$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. fixtures numerical.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then /^contains the correct numerical questions$/ do
  @questions.length.should be(2)
  
  #When was Harvey D. Smith born?{#1945:5}
  question = @questions[0]
  assert_equal 1, question.answer.length
  assert_question question, :style => :numerical,
                            :text => "When was Harvey D. Smith born?",
                            :title => nil

  assert_answer question.answer[0], :correct => 1945, :range => 5, :weight => nil
  
  #//this comment will be ignored in the import process 
  #::Numerical example::
  #When was Elizabeth M. Danson born? {#
  #    =1993:0      #Correct!  you will get full credit for this answer
  #    =%50%1993:2  #She was born in 1993.
  #                 You get 50% credit for being close.
  #}
  question = @questions[1]
  assert_equal 2, question.answer.length
  assert_question question, :style => :numerical,
                            :text => "When was Elizabeth M. Danson born?",
                            :title => "Numerical example"

  assert_answer question.answer[0], :correct => 1993, :range => 0, :weight => nil, :comment => "Correct!  you will get full credit for this answer"
  assert_answer question.answer[1], :correct => 1993, :range => 2, :weight => 50, :comment => "She was born in 1993.\n                 You get 50% credit for being close."
end

