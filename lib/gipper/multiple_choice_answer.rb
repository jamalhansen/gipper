module Gipper
  class MultipleChoiceAnswer
    attr_reader :correct, :text
    
    def initialize clause
      @correct = is_the_correct_multiple_choice clause
      @text = clause[1..clause.length].strip
    end
    
    def is_the_correct_multiple_choice clause
      return :true if (clause[0] == 61)
      return :false
    end
  end
end
