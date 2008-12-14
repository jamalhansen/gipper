module Gipper
  class AnswerParser
    def parse text
      if can_parse? text
        return extract_answers_from(text, Answers.new)
      end
      
      if can_parse_as_true_false? text
        answer = Gipper::Answers.new
        h = Hash.new
        h[:correct] = is_a_true text
        answer << h
        
        return answer
      end
      
      throw "could not parse text."
    end
    
    def is_a_true answer
      if !(answer.downcase.strip =~ /^(t|true)$/).nil?
        return :true
      end
      
      return :false
    end
    
    def can_parse? text
      return false if text.nil?
            
      !(text.strip =~ /((~|=)[^(~|=)]+)+/).nil?
    end
    
    def can_parse_as_true_false? answer
      return false if answer.nil?

      !(answer.downcase.strip =~ /^(t|f|true|false)$/).nil?
    end
    
    # tail recursive function to parse answers
    def extract_answers_from answer, answers
      head, tail = split_head_from answer 
      return answers if head.nil?
      
      obj = {}
      parse_clause head, obj
      answers << obj

      extract_answers_from tail, answers
    end
    
    # splits the head from the remaining clauses
    def split_head_from clauses
      matches = /([~=][^(~|=)]+)(([~=][^(~|=)]+)*)/.match clauses
      
      return [matches[1], matches[2]] if matches
      return [nil, nil]
    end

    ###############################################
    def is_the_correct_choice clause
      return :true if (clause[0] == 61)
      return :false
    end
    
    def parse_clause text, to_hash
      to_hash[:correct] = is_the_correct_choice text
      answer_text = text[1..text.length].strip
      to_hash[:text], to_hash[:comment] = split_comment(answer_text)
      
      to_hash
    end
    
    def split_comment answer_text
      reg = Regexp.new('(.*)#(.*)', Regexp::MULTILINE)
      matches = reg.match answer_text
      
      return [matches[1].strip, matches[2].strip] if matches
      return [answer_text, nil]
    end
  end
end
