module Gipper
  class TrueFalseAnswerParser
    def TrueFalseAnswerParser.can_parse? answer
      return false if answer.nil?

      !(answer.downcase.strip =~ /^(t|f|true|false)$/).nil?
    end
    
    def is_a_true answer
      !(answer.downcase.strip =~ /^(t|true)$/).nil?
    end
    
    def parse text
      answer = {}
      answer[:answer] = is_a_true text
      answer[:style] = :true_false 
      
      answer
    end
  end
end
