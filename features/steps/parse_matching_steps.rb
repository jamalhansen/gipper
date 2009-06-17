
Given /^a GIFT file of matching questions$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. fixtures matching.gift]))
  @data = file.read
  assert @data.length > 0
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
  assert_equal 1, @questions.length
  
  question = @questions[0]
  assert_equal 4, question.answer.length
  assert_question question, :style => :matching,
                            :text => "Match the emoticon to the correct emotion:",
                            :title => "Intro to matching questions"

  assert_answer question.answer[0], :correct => "smiling", :text => ":)"
  assert_answer question.answer[1], :correct => "crazy happy", :text => ":D"
  assert_answer question.answer[2], :correct => "yay!", :text => '\\(^_^)/'
  assert_answer question.answer[3], :correct => "sad", :text => ":("
end

