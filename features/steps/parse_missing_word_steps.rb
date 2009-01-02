Given /^a GIFT file of missing word questions$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. .. spec files missing_word.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then /^contains the correct missing word questions$/ do
  @questions.length.should be(4)
 
  #Sally sells {  =seashells  ~snails} by the seashore.
  @questions[0].style.should eql(:missing_word)
  @questions[0].text.should eql("Sally sells")
  @questions[0].text_post.should eql("by the seashore.")
  @questions[0].title.should eql(nil)
  @questions[0].answer.length.should eql(2)
  @questions[0].answer[0].text.should eql("seashells")
  @questions[0].answer[0].correct.should eql(true)
  @questions[0].answer[1].text.should eql("snails")
  @questions[0].answer[1].correct.should eql(false)
  
  #::Hamster Tree::
  #Oh woe is me, {~oh =doh!} woe is me!
  @questions[1].style.should eql(:missing_word)
  @questions[1].text.should eql("Oh woe is me,")
  @questions[1].text_post.should eql("woe is me!")
  @questions[1].title.should eql("Hamster Tree")
  @questions[1].answer.length.should eql(2)
  @questions[1].answer[0].text.should eql("oh")
  @questions[1].answer[0].correct.should eql(false)
  @questions[1].answer[1].text.should eql("doh!")
  @questions[1].answer[1].correct.should eql(true)
  
  #You say that, "money is the root of all evil", I ask you "what is the root of all {~honey ~bunnies =money}?"
  @questions[2].style.should eql(:missing_word)
  @questions[2].text.should eql('You say that, "money is the root of all evil", I ask you "what is the root of all')
  @questions[2].text_post.should eql('?"')
  @questions[2].title.should eql(nil)
  @questions[2].answer.length.should eql(3)
  @questions[2].answer[0].text.should eql("honey")
  @questions[2].answer[0].correct.should eql(false)
  @questions[2].answer[1].text.should eql("bunnies")
  @questions[2].answer[1].correct.should eql(false)
  @questions[2].answer[2].text.should eql("money")
  @questions[2].answer[2].correct.should eql(true)
  
  #Ooh Eee \{Uh\} Ooh Ah Ah {=Ting Tang ~Tung Ting ~Wing Wang} Walla Walla Bing Bang!
  @questions[3].style.should eql(:missing_word)
  @questions[3].text.should eql('Ooh Eee {Uh} Ooh Ah Ah')
  @questions[3].text_post.should eql("Walla Walla Bing Bang!")
  @questions[3].title.should eql(nil)
  @questions[3].answer.length.should eql(3)
  @questions[3].answer[0].text.should eql("Ting Tang")
  @questions[3].answer[0].correct.should eql(true)
  @questions[3].answer[1].text.should eql("Tung Ting")
  @questions[3].answer[1].correct.should eql(false)
  @questions[3].answer[2].text.should eql("Wing Wang")
  @questions[3].answer[2].correct.should eql(false)
end

