require File.join(File.dirname(__FILE__), *%w[spec_helper.rb])

describe Gipper::Quiz do
  
  before(:each) do
    @single_question = "This is a really lame question"
    @single_answer = "{T}"
  end

  it "should remove commented lines before parsing" do
    file = File.open(File.join(File.dirname(__FILE__), *%w[files begins_with_comment.txt]))
    Gipper::Quiz.new.iterate_through file.read do |q|
      q.should eql("1=1{T}")
    end
  end


  it "should return just a question mark for question_post when question_post is just a question mark" do
    quiz = Gipper::Quiz.parse 'You say that, "money is the root of all evil", I ask you "what is the root of all {~honey ~bunnies =money}?"'
    quiz[0].text.should eql('You say that, "money is the root of all evil", I ask you "what is the root of all')
    quiz[0].text_post.should eql('?"')

    answers = quiz[0].answer
    answers[0].correct.should eql(false)
    answers[0].text.should eql("honey")
    answers[1].correct.should eql(false)
    answers[1].text.should eql("bunnies")
    answers[2].correct.should eql(true)
    answers[2].text.should eql("money")
  end
  
  describe "(when passed an empty string)" do
    it "should return an empty array" do
      quiz = Gipper::Quiz.parse("")
      quiz.should eql([])
    end
  end
  
  describe "(when passed more than one question)" do
    it "should return an array with questions" do
      q = []
      q << true_false_question("Weather Patterns in the Pacific Northwest", "Seattle is rainy.", "{T}")
      q << true_false_question("", "Seattle has lots of water.", "{T}")
      q << true_false_question("Accessories in the Pacific Northwest", "People in Seattle use umbrellas:", "{T}")

      multiple_input = "//opening comment\r\n//another comment\r\n\r\n\r\n#{q[0]}\r\n//this is a \r\n//couple rows of comments\r\n\r\n#{q[1]}\r\n\r\n#{q[2]}"

      Gipper::Quiz.new.iterate_through(multiple_input) do |qu|
        q.include?(qu).should eql(true)
      end
    end
    
    it "ignore whitespace between questions" do
      quiz = "a\r\n\t\r\nb\r\n      \r\nc\r\n\r\nd"
      count = 0

      Gipper::Quiz.new.iterate_through(quiz) do |qu|
        expected = ['a', 'b', 'c', 'd']
        qu.should eql(expected[count])  
        count = count + 1        
      end
      count.should eql(4)
    end
  end
end
