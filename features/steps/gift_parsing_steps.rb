
Given /^a GIFT file$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. .. spec files super_gift.txt]))
  @data = file.read
  @data.length.should be > 0
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
  #
  #Four plus one equals {5}
  #
  #Three plus {2} equals five.
  #
  #Grant is buried in Grant's tomb.{F}
  #
  #    The sun rises in the east.{T}
  #   
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
  #     
  #     Match the following countries with their corresponding capitals. {
  #         =Canada -> Ottawa
  #         =Italy  -> Rome
  #         =Japan  -> Tokyo
  #         =India  -> New Delhi
  #         }
  #
  #// ------------------------------------------
  #// Numerical
  #// ------------------------------------------
  #
  #     When was Ulysses S. Grant born? {#1822}
  #
  #     What is the value of pi (to 3 decimal places)? {#3.1415:0.0005}
  #
  #     What is the value of pi (to 3 decimal places)? {#3.141..3.142}
  #
  #     When was Ulysses S. Grant born? {#
  #         =1822:0
  #         =%50%1822:2}
  #
  #
  #//Line Comments:
  #
  #// Subheading: Numerical questions below
  #What's 2 plus 2? {#4}
  #     
  #//Question Name:
  #::Kanji Origins::Japanese characters originally
  #came from what country? {=China}
  #
  # ::Thanksgiving Date::The American holiday of Thanksgiving is 
  # celebrated on the {~second ~third =fourth} Thursday of November.
  #
  #//Feedback:
  #
  #     What's the answer to this multiple-choice question?{
  #     ~wrong answer#feedback comment on the wrong answer
  #     ~another wrong answer#feedback comment on this wrong answer
  #     =right answer#Very good!}
  #     
  #     Who's buried in Grant's tomb?{
  #     =no one#excellent answer!
  #     =nobody#excellent answer!}
  #     
  #     Grant is buried in Grant's tomb.{FALSE#No one is buried in Grant's tomb.}
  #
  #//Percentage Answer Weights:
  #//Percentage answer weights are available for both Multiple Choice and Short Answer questions. Percentage answer weights can be included by following the tilde (for Multiple Choice) or equal sign (for Short Answer) with the desired percent enclosed within percent signs (e.g., %50%). 
  #//This option can be combined with feedback comments.
  #
  #     Difficult question.{~wrong answer ~%50%half credit answer =full credit answer}
  #          
  #     ::Jesus' hometown::Jesus Christ was from {
  #     ~Jerusalem#This was an important city, but the wrong answer.
  #     ~%25%Bethlehem#He was born here, but not raised here.
  #     ~%50%Galilee#You need to be more specific.
  #     =Nazareth#Yes! That's right!}.
  #     
  #     ::Jesus' hometown:: Jesus Christ was from {
  #     =Nazareth#Yes! That's right!
  #     =%75%Nazereth#Right, but misspelled.
  #     =%25%Bethlehem#He was born here, but not raised here.}
  #
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
  #     
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
  #          ~Grant's father }Note that there is no equal sign (=) in any answer and the answers should total no more than 100%, otherwise Moodle will return an error. To avoid the problem of students automatically getting 100% by simply checking all of the answers, it is best to include negative answer weights for wrong answers.
  #
  #     What two people are entombed in Grant's tomb? {
  #          ~%-50%No one
  #          ~%50%Grant
  #          ~%50%Grant's wife
  #          ~%-50%Grant's father }
  #          
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
  throw "need to implement more"
end

