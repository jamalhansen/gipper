module Gipper
  class MultipleChoiceAnswerParser
    def MultipleChoiceAnswerParser.can_parse? text
      return false if text.nil?
            
      !(text.strip =~ /((~|=)[^(~|=)]+)+/).nil?
    end
    
    # tail recursive function to parse answers
    def extract_multiple_choices_from answer, answers
      head, tail = split_multiple_choice answer 
      return answers if head.nil?
      
      obj = Gipper::MultipleChoiceAnswer.new head 
      answers << obj

      extract_multiple_choices_from tail, answers
    end
    
    # splits the head from the remaining clauses
    def split_multiple_choice clauses
      matches = /([~=][^(~|=)]+)(([~=][^(~|=)]+)*)/.match clauses
      
      return [matches[1], matches[2]] if matches
      return [nil, nil]
    end
    
    def parse text
      answer = {}
      answer[:answers] = extract_multiple_choices_from text, []
      answer[:style] = :multiple_choice
      answer
    end
  end
end
