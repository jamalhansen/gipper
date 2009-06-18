
Given /^a GIFT file$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. fixtures super_gift.txt]))
  @data = file.read
  assert @data.length > 0
end

Then /^contains the correct questions$/ do 
  #// Basic GIFT questions
  #// GIFT filter and documentation by Paul Tsuchido Shew http://ac.shew.jp.
  #//---------------------------
  #
  #Who's buried in Grant's tomb?{~Grant ~Jefferson =no one}
  @questions[0].style.should eql(:multiple_choice)
  @questions[0].text.should eql("Who's buried in Grant's tomb?")
  @questions[0].text_post.should eql(nil)
  @questions[0].title.should eql(nil)
  @questions[0].answer.length.should eql(3)
  @questions[0].answer[0].correct.should eql(false)
  @questions[0].answer[0].text.should eql("Grant")
  @questions[0].answer[1].correct.should eql(false)
  @questions[0].answer[1].text.should eql("Jefferson")
  @questions[0].answer[2].correct.should eql(true)
  @questions[0].answer[2].text.should eql("no one")

  #Grant is {~buried =entombed ~living} in Grant's tomb.
  @questions[1].style.should eql(:missing_word)
  @questions[1].text.should eql("Grant is")
  @questions[1].text_post.should eql("in Grant's tomb.")
  @questions[1].title.should eql(nil)
  @questions[1].answer.length.should eql(3)
  @questions[1].answer[0].correct.should eql(false)
  @questions[1].answer[0].text.should eql("buried")
  @questions[1].answer[1].correct.should eql(true)
  @questions[1].answer[1].text.should eql("entombed")
  @questions[1].answer[2].correct.should eql(false)
  @questions[1].answer[2].text.should eql("living")

  #//----------------------------------
  #// Formatting
  #//----------------------------------
  #The American holiday of Thanksgiving is celebrated on the {
  #   ~second
  #   ~third
  #   =fourth
  #} Thursday of November.
  @questions[2].style.should eql(:missing_word)
  @questions[2].text.should eql("The American holiday of Thanksgiving is celebrated on the")
  @questions[2].text_post.should eql("Thursday of November.")
  @questions[2].title.should eql(nil)
  @questions[2].answer.length.should eql(3)
  @questions[2].answer[0].correct.should eql(false)
  @questions[2].answer[0].text.should eql("second")
  @questions[2].answer[1].correct.should eql(false)
  @questions[2].answer[1].text.should eql("third")
  @questions[2].answer[2].correct.should eql(true)
  @questions[2].answer[2].text.should eql("fourth")
  #
  #Japanese characters originally came from what country? {
  #   ~India
  #   =China
  #   ~Korea
  #   ~Egypt}
  @questions[3].style.should eql(:multiple_choice)
  @questions[3].text.should eql("Japanese characters originally came from what country?")
  @questions[3].text_post.should eql(nil)
  @questions[3].title.should eql(nil)
  @questions[3].answer.length.should eql(4)
  @questions[3].answer[0].correct.should eql(false)
  @questions[3].answer[0].text.should eql("India")
  @questions[3].answer[1].correct.should eql(true)
  @questions[3].answer[1].text.should eql("China")
  @questions[3].answer[2].correct.should eql(false)
  @questions[3].answer[2].text.should eql("Korea")
  @questions[3].answer[3].correct.should eql(false)
  @questions[3].answer[3].text.should eql("Egypt") 
  
  #Who's buried in Grant's tomb?{=no one =nobody}
  @questions[4].style.should eql(:short_answer)
  @questions[4].text.should eql("Who's buried in Grant's tomb?")
  @questions[4].text_post.should eql(nil)
  @questions[4].title.should eql(nil)
  @questions[4].answer.length.should eql(2)
  @questions[4].answer[0].correct.should eql(true)
  @questions[4].answer[0].text.should eql("no one")
  @questions[4].answer[1].correct.should eql(true)
  @questions[4].answer[1].text.should eql("nobody")
  
  #Two plus two equals {=four =4}
  @questions[5].style.should eql(:short_answer)
  @questions[5].text.should eql("Two plus two equals")
  @questions[5].text_post.should eql(nil)
  @questions[5].title.should eql(nil)
  @questions[5].answer.length.should eql(2)
  @questions[5].answer[0].correct.should eql(true)
  @questions[5].answer[0].text.should eql("four")
  @questions[5].answer[1].correct.should eql(true)
  @questions[5].answer[1].text.should eql("4")
  
  #Four plus one equals {5}
  @questions[6].style.should eql(:short_answer)
  @questions[6].text.should eql("Four plus one equals")
  @questions[6].text_post.should eql(nil)
  @questions[6].title.should eql(nil)
  @questions[6].answer.length.should eql(1)
  @questions[6].answer[0].correct.should eql(true)
  @questions[6].answer[0].text.should eql("5")
  
  
  #Three plus {2} equals five.
  @questions[7].style.should eql(:missing_word)
  @questions[7].text.should eql("Three plus")
  @questions[7].text_post.should eql("equals five.")
  @questions[7].title.should eql(nil)
  @questions[7].answer.length.should eql(1)
  @questions[7].answer[0].correct.should eql(true)
  @questions[7].answer[0].text.should eql("2")
  
  #Grant is buried in Grant's tomb.{F}
  @questions[8].style.should eql(:true_false)
  @questions[8].text.should eql("Grant is buried in Grant's tomb.")
  @questions[8].text_post.should eql(nil)
  @questions[8].title.should eql(nil)
  @questions[8].answer.length.should eql(1)
  @questions[8].answer[0].correct.should eql(false)
  
  #    The sun rises in the east.{T}
  @questions[9].style.should eql(:true_false)
  @questions[9].text.should eql("The sun rises in the east.")
  @questions[9].text_post.should eql(nil)
  @questions[9].title.should eql(nil)
  @questions[9].answer.length.should eql(1)
  @questions[9].answer[0].correct.should eql(true)
  
  #// ------------------------------------------
  #// Matching
  #// There must be at least three matching pairs.
  #// Matching questions do not support feedback or percentage answer weights.
  #// ------------------------------------------
  #
  #     Matching Question. {
  #         =subquestion1 -> subanswer1
  #         =subquestion2 -> subanswer2
  #         =subquestion3 -> subanswer3
  #         }
  @questions[10].style.should eql(:matching)
  @questions[10].text.should eql("Matching Question.")
  @questions[10].text_post.should eql(nil)
  @questions[10].title.should eql(nil)
  @questions[10].answer.length.should eql(3)
  @questions[10].answer[0].text.should eql("subquestion1")
  @questions[10].answer[0].correct.should eql("subanswer1")
  @questions[10].answer[1].text.should eql("subquestion2")
  @questions[10].answer[1].correct.should eql("subanswer2")
  @questions[10].answer[2].text.should eql("subquestion3")
  @questions[10].answer[2].correct.should eql("subanswer3")
  
  #     Match the following countries with their corresponding capitals. {
  #         =Canada -> Ottawa
  #         =Italy  -> Rome
  #         =Japan  -> Tokyo
  #         =India  -> New Delhi
  #         }
  question = @questions[11]
  question.style.should eql(:matching)
  question.text.should eql("Match the following countries with their corresponding capitals.")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(4)
  question.answer[0].text.should eql("Canada")
  question.answer[0].correct.should eql("Ottawa")
  question.answer[1].text.should eql("Italy")
  question.answer[1].correct.should eql("Rome")
  question.answer[2].text.should eql("Japan")
  question.answer[2].correct.should eql("Tokyo")
  question.answer[3].text.should eql("India")
  question.answer[3].correct.should eql("New Delhi")
  
  #// ------------------------------------------
  #// Numerical
  #// ------------------------------------------
  #
  #     When was Ulysses S. Grant born? {#1822}
  question = @questions[12]
  question.style.should eql(:numerical)
  question.text.should eql("When was Ulysses S. Grant born?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(1)
  question.answer[0].correct.should eql(1822)
  question.answer[0].range.should eql(0)
  question.answer[0].weight.should eql(nil)
  
  #     What is the value of pi (to 3 decimal places)? {#3.1415:0.0005}
  question = @questions[13]
  question.style.should eql(:numerical)
  question.text.should eql("What is the value of pi (to 3 decimal places)?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(1)
  question.answer[0].correct.should eql(3.1415)
  question.answer[0].range.should eql(0.0005)
  question.answer[0].weight.should eql(nil)
  
  #     What is the value of pi (to 3 decimal places)? {#3.141..3.142}
  question = @questions[14]
  question.style.should eql(:numerical)
  question.text.should eql("What is the value of pi (to 3 decimal places)?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(1)
  (question.answer[0].correct * 100000).round.should eql(314150)
  (question.answer[0].range * 100000).round.should eql(50)
  question.answer[0].weight.should eql(nil)
  
  #     When was Ulysses S. Grant born? {#
  #         =1822:0
  #         =%50%1822:2}
  question = @questions[15]
  question.style.should eql(:numerical)
  question.text.should eql("When was Ulysses S. Grant born?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(2)
  question.answer[0].correct.should eql(1822)
  question.answer[0].range.should eql(0)
  question.answer[0].weight.should eql(nil)
  question.answer[1].correct.should eql(1822)
  question.answer[1].range.should eql(2)
  question.answer[1].weight.should eql(50)
  
  #
  #//Line Comments:
  #
  #// Subheading: Numerical questions below
  #What's 2 plus 2? {#4}
  question = @questions[16]
  question.style.should eql(:numerical)
  question.text.should eql("What's 2 plus 2?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(1)
  question.answer[0].correct.should eql(4)
  question.answer[0].range.should eql(0)
  question.answer[0].weight.should eql(nil)
  
  #//Question Name:
  #::Kanji Origins::Japanese characters originally
  #came from what country? {=China}
  question = @questions[17]
  question.style.should eql(:short_answer)
  question.text.should eql("Japanese characters originally\ncame from what country?")
  question.text_post.should eql(nil)
  question.title.should eql("Kanji Origins")
  question.answer.length.should eql(1)
  question.answer[0].correct.should eql(true)
  question.answer[0].text.should eql("China")
  
  # ::Thanksgiving Date::The American holiday of Thanksgiving is 
  # celebrated on the {~second ~third =fourth} Thursday of November.
  question = @questions[18]
  question.style.should eql(:missing_word)
  question.text.should eql("The American holiday of Thanksgiving is \n celebrated on the")
  question.text_post.should eql("Thursday of November.")
  question.title.should eql("Thanksgiving Date")
  question.answer.length.should eql(3)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql("second")
  question.answer[1].correct.should eql(false)
  question.answer[1].text.should eql("third")
  question.answer[2].correct.should eql(true)
  question.answer[2].text.should eql("fourth")
  
  #//Feedback:
  #
  #     What's the answer to this multiple-choice question?{
  #     ~wrong answer#feedback comment on the wrong answer
  #     ~another wrong answer#feedback comment on this wrong answer
  #     =right answer#Very good!}
  question = @questions[19]
  question.style.should eql(:multiple_choice)
  question.text.should eql("What's the answer to this multiple-choice question?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(3)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql("wrong answer")
  question.answer[0].comment.should eql("feedback comment on the wrong answer")
  question.answer[1].correct.should eql(false)
  question.answer[1].text.should eql("another wrong answer")
  question.answer[1].comment.should eql("feedback comment on this wrong answer")
  question.answer[2].correct.should eql(true)
  question.answer[2].text.should eql("right answer")
  question.answer[2].comment.should eql("Very good!")
  #     
  #     Who's buried in Grant's tomb?{
  #     =no one#excellent answer!
  #     =nobody#excellent answer!}
  question = @questions[20]
  question.style.should eql(:short_answer)
  question.text.should eql("Who's buried in Grant's tomb?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(2)
  question.answer[0].correct.should eql(true)
  question.answer[0].text.should eql("no one")
  question.answer[0].comment.should eql("excellent answer!")
  question.answer[1].correct.should eql(true)
  question.answer[1].text.should eql("nobody")
  question.answer[1].comment.should eql("excellent answer!")
  
  #     Grant is buried in Grant's tomb.{FALSE#No one is buried in Grant's tomb.}
  question = @questions[21]
  question.style.should eql(:true_false)
  question.text.should eql("Grant is buried in Grant's tomb.")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(1)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql(nil)
  question.answer[0].comment.should eql("No one is buried in Grant's tomb.")
  
  #//Percentage Answer Weights:
  #//Percentage answer weights are available for both Multiple Choice and Short Answer questions. Percentage answer weights can be included by following the tilde (for Multiple Choice) or equal sign (for Short Answer) with the desired percent enclosed within percent signs (e.g., %50%). 
  #//This option can be combined with feedback comments.
  #
  #     Difficult question.{~wrong answer ~%50%half credit answer =full credit answer}
  question = @questions[22]
  question.style.should eql(:multiple_choice)
  question.text.should eql("Difficult question.")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(3)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql("wrong answer")
  question.answer[0].weight.should eql(nil)
  question.answer[1].correct.should eql(false)
  question.answer[1].text.should eql("half credit answer")
  question.answer[1].weight.should eql(50)
  question.answer[2].correct.should eql(true)
  question.answer[2].text.should eql("full credit answer")
  question.answer[2].weight.should eql(nil)
  
  #     ::Jesus' hometown::Jesus Christ was from {
  #     ~Jerusalem#This was an important city, but the wrong answer.
  #     ~%25%Bethlehem#He was born here, but not raised here.
  #     ~%50%Galilee#You need to be more specific.
  #     =Nazareth#Yes! That's right!}.
  question = @questions[23]
  question.style.should eql(:missing_word)
  question.text.should eql("Jesus Christ was from")
  question.text_post.should eql(".")
  question.title.should eql("Jesus' hometown")
  question.answer.length.should eql(4)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql("Jerusalem")
  question.answer[0].weight.should eql(nil)
  question.answer[0].comment.should eql("This was an important city, but the wrong answer.")
  
  question.answer[1].correct.should eql(false)
  question.answer[1].text.should eql("Bethlehem")
  question.answer[1].weight.should eql(25)
  question.answer[1].comment.should eql("He was born here, but not raised here.")
  
  question.answer[2].correct.should eql(false)
  question.answer[2].text.should eql("Galilee")
  question.answer[2].weight.should eql(50)
  question.answer[2].comment.should eql("You need to be more specific.")
  
  question.answer[3].correct.should eql(true)
  question.answer[3].text.should eql("Nazareth")
  question.answer[3].weight.should eql(nil)
  question.answer[3].comment.should eql("Yes! That's right!")
  
  #     ::Jesus' hometown:: Jesus Christ was from {
  #     =Nazareth#Yes! That's right!
  #     =%75%Nazereth#Right, but misspelled.
  #     =%25%Bethlehem#He was born here, but not raised here.}
  question = @questions[24]
  question.style.should eql(:short_answer)
  question.text.should eql("Jesus Christ was from")
  question.text_post.should eql(nil)
  question.title.should eql("Jesus' hometown")
  question.answer.length.should eql(3)
  question.answer[0].correct.should eql(true)
  question.answer[0].text.should eql("Nazareth")
  question.answer[0].weight.should eql(nil)
  question.answer[0].comment.should eql("Yes! That's right!")
  
  question.answer[1].correct.should eql(true)
  question.answer[1].text.should eql("Nazereth")
  question.answer[1].weight.should eql(75)
  question.answer[1].comment.should eql("Right, but misspelled.")
  
  question.answer[2].correct.should eql(true)
  question.answer[2].text.should eql("Bethlehem")
  question.answer[2].weight.should eql(25)
  question.answer[2].comment.should eql("He was born here, but not raised here.")
  
  #//Specify text-formatting for the question
  #//The question text (only) may have an optional text format specified. 
  #//Currently the available formats are moodle (Moodle Auto-Format), html (HTML format), plain (Plain text format) and markdown (Markdown format). 
  #//The format is specified in square brackets immediately before the question text. More information on text formats in Moodle.
  #
  #[markdown]The *American holiday of Thanksgiving* is celebrated on the {
  #         ~second
  #         ~third
  #         =fourth
  #     } Thursday of November.    
  question = @questions[25]
  question.format = "markdown"
  question.style.should eql(:missing_word)
  question.text.should eql("The *American holiday of Thanksgiving* is celebrated on the")
  question.text_post.should eql("Thursday of November.")
  question.title.should eql(nil)
  question.answer.length.should eql(3)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql("second")
  question.answer[1].correct.should eql(false)
  question.answer[1].text.should eql("third")
  question.answer[2].correct.should eql(true)
  question.answer[2].text.should eql("fourth")
  
  #//Multiple Answers:
  #//The Multiple Answers option is used for multiple choice questions when 
  #//two or more answers must be selected in order to obtain full credit. 
  #//The multiple answers option is enabled by assigning partial answer weight to
  #//multiple answers, while allowing no single answer to receive full credit.
  #
  #     What two people are entombed in Grant's tomb? {
  #          ~No one
  #          ~%50%Grant
  #          ~%50%Grant's wife
  #          ~Grant's father }
  #//Note that there is no equal sign (=) in any answer and the answers should total no more than 100%, otherwise Moodle will return an error. To avoid the problem of students automatically getting 100% by simply checking all of the answers, it is best to include negative answer weights for wrong answers.
  question = @questions[26]
  question.style.should eql(:multiple_choice)
  question.text.should eql("What two people are entombed in Grant's tomb?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(4)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql("No one")
  question.answer[0].weight.should eql(nil)
  question.answer[1].correct.should eql(false)
  question.answer[1].text.should eql("Grant")
  question.answer[1].weight.should eql(50)
  question.answer[2].correct.should eql(false)
  question.answer[2].text.should eql("Grant's wife")
  question.answer[2].weight.should eql(50)
  question.answer[3].correct.should eql(false)
  question.answer[3].text.should eql("Grant's father")
  question.answer[3].weight.should eql(nil)


  #     What two people are entombed in Grant's tomb? {
  #          ~%-50%No one
  #          ~%50%Grant
  #          ~%50%Grant's wife
  #          ~%-50%Grant's father }
  
  question = @questions[27]
  question.style.should eql(:multiple_choice)
  question.text.should eql("What two people are entombed in Grant's tomb?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(4)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql("No one")
  question.answer[0].weight.should eql(-50)
  question.answer[1].correct.should eql(false)
  question.answer[1].text.should eql("Grant")
  question.answer[1].weight.should eql(50)
  question.answer[2].correct.should eql(false)
  question.answer[2].text.should eql("Grant's wife")
  question.answer[2].weight.should eql(50)
  question.answer[3].correct.should eql(false)
  question.answer[3].text.should eql("Grant's father")
  question.answer[3].weight.should eql(-50)         
  #//Special Characters ~ = # { } :
  #//These symbols ~ = # { } control the operation of this filter 
  #//and cannot be used as normal text within questions. 
  #//Since these symbols have a special role in determining the 
  #//operation of this filter, they are called "control characters." 
  #//But sometimes you may want to use one of these characters, 
  #//for example to show a mathematical formula in a question. 
  #//The way to get around this problem is "escaping" the control characters.
  #//This means simply putting a backslash (\) before a control character 
  #//so the filter will know that you want to use it as a literal character 
  #//instead of as a control character. For example:
  #
  #     Which answer equals 5? {
  #          ~ \= 2 + 2
  #          = \= 2 + 3
  #          ~ \= 2 + 4  }
  question = @questions[28]
  question.style.should eql(:multiple_choice)
  question.text.should eql("Which answer equals 5?")
  question.text_post.should eql(nil)
  question.title.should eql(nil)
  question.answer.length.should eql(3)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql("= 2 + 2")
  question.answer[1].correct.should eql(true)
  question.answer[1].text.should eql("= 2 + 3")
  question.answer[2].correct.should eql(false)
  question.answer[2].text.should eql("= 2 + 4")
  #
  #     ::GIFT Control Characters::
  #     Which of the following is NOT a control character for the GIFT import format? {
  #        ~ \~     # \~ is a control character.
  #        ~ \=     # \= is a control character.
  #        ~ \#     # \# is a control character.
  #        ~ \{     # \{ is a control character.
  #        ~ \}     # \} is a control character.
  #        = \     # Correct! \ (backslash) is not a control character. BUT,
  #                   it is used to escape the control characters.
  #     }
  question = @questions[29]
  question.style.should eql(:multiple_choice)
  question.text.should eql("Which of the following is NOT a control character for the GIFT import format?")
  question.text_post.should eql(nil)
  question.title.should eql("GIFT Control Characters")
  question.answer.length.should eql(6)
  question.answer[0].correct.should eql(false)
  question.answer[0].text.should eql("~")
  question.answer[0].comment.should eql("~ is a control character.")
  question.answer[1].correct.should eql(false)
  question.answer[1].text.should eql("=")
  question.answer[1].comment.should eql("= is a control character.")
  question.answer[2].correct.should eql(false)
  question.answer[2].text.should eql("#")
  question.answer[2].comment.should eql("# is a control character.")
  question.answer[3].correct.should eql(false)
  question.answer[3].text.should eql("{")
  question.answer[3].comment.should eql("{ is a control character.")
  question.answer[4].correct.should eql(false)
  question.answer[4].text.should eql("}")
  question.answer[4].comment.should eql("} is a control character.")
  question.answer[5].correct.should eql(true)
  question.answer[5].text.should eql("\\")
  question.answer[5].comment.should eql("Correct! \\ (backslash) is not a control character. BUT,
                   it is used to escape the control characters.")

end

