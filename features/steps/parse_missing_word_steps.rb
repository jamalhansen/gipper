Given /^a GIFT file of missing word questions$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. fixtures missing_word.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then /^contains the correct missing word questions$/ do
  @questions.length.should be(4)
 
  #Sally sells {  =seashells  ~snails} by the seashore.
  question = @questions[0]
  assert_equal 2, question.answer.length
  assert_question question, :style => :missing_word,
                            :text => "Sally sells",
                            :title => nil,
                            :text_post => "by the seashore."

  assert_answer question.answer[0], :correct => true, :text => "seashells"
  assert_answer question.answer[1], :correct => false, :text => "snails"

  
  #::Hamster Tree::
  #Oh woe is me, {~oh =doh!} woe is me!
  question = @questions[1]
  assert_equal 2, question.answer.length
  assert_question question, :style => :missing_word,
                            :text => "Oh woe is me,",
                            :title => "Hamster Tree",
                            :text_post => "woe is me!"

  assert_answer question.answer[0], :correct => false, :text => "oh"
  assert_answer question.answer[1], :correct => true, :text => "doh!"
  
  #You say that, "money is the root of all evil", I ask you "what is the root of all {~honey ~bunnies =money}?"
  question = @questions[2]
  assert_equal 3, question.answer.length
  assert_question question, :style => :missing_word,
                            :text => 'You say that, "money is the root of all evil", I ask you "what is the root of all',
                            :title => nil,
                            :text_post => '?"'

  assert_answer question.answer[0], :correct => false, :text => "honey"
  assert_answer question.answer[1], :correct => false, :text => "bunnies"
  assert_answer question.answer[2], :correct => true, :text => "money"
  
  #Ooh Eee \{Uh\} Ooh Ah Ah {=Ting Tang ~Tung Ting ~Wing Wang} Walla Walla Bing Bang!
  question = @questions[3]
  assert_equal 3, question.answer.length
  assert_question question, :style => :missing_word,
                            :text => 'Ooh Eee {Uh} Ooh Ah Ah',
                            :title => nil,
                            :text_post => "Walla Walla Bing Bang!"

  assert_answer question.answer[0], :correct => true, :text => "Ting Tang"
  assert_answer question.answer[1], :correct => false, :text => "Tung Ting"
  assert_answer question.answer[2], :correct => false, :text => "Wing Wang"
end

