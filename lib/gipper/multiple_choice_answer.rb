module Gipper
  class MultipleChoiceAnswer
    attr_reader :correct, :text, :comment
    
    def initialize clause
      @correct, @text, @comment = parse clause
    end
    
    def is_the_correct_multiple_choice clause
      return :true if (clause[0] == 61)
      return :false
    end
    
    def parse clause
      correct = is_the_correct_multiple_choice clause
      answer_text = clause[1..clause.length].strip
      text, comment = split_comment(answer_text)
      
      return correct, text, comment 
    end
    
    def split_comment answer_text
      reg = Regexp.new('(.*)#(.*)', Regexp::MULTILINE)
      matches = reg.match answer_text
      
      return [matches[1].strip, matches[2].strip] if matches
      return [answer_text, nil]
    end
  end
end
