module Gipper
  class AnswerParser
    def parse text, answers
      if can_parse? text
        return extract_answers_from(text, answers)
      end
      
      if can_parse_as_true_false? text
        return extract_true_false_answers_from(text, answers)
      end
      
      throw "could not parse text."
    end
    
    def extract_true_false_answers_from text, answers
        h = Hash.new
        h[:correct] = is_a_true text
        answers << h
        
        return answers  
    end
    
    def is_a_true answer
      if !(answer.downcase.strip =~ /^(t|true)$/).nil?
        return :true
      end
      
      return :false
    end
    
    def can_parse? text
      return false if text.nil?
            
      !(text.strip =~ /^([~=][^~=]+)+$/).nil?
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
      clauses.strip!
      matches = /^([~=][^~=]+)(([~=][^~=]+)*)$/.match clauses
      
      return [matches[1], matches[2]] if matches
      return [nil, nil]
    end

    ###############################################
    def split_correct clause
      reg = Regexp.new('^([~=])([^\-\>]+)(\-\>(.*))?$', Regexp::MULTILINE)
      matches = reg.match clause

      correct_answer = eval_correctness matches[1]
      text = matches[2].strip
      matching = matches[4].strip if matches[4]

      return [text, matching] if !matching.nil?
      return [text, correct_answer]
    end
    
    def eval_correctness indicator
      return :true if indicator == "="
      return :false
    end
    
    def parse_clause text, to_hash
      text, to_hash[:correct] = split_correct text
      to_hash[:text], to_hash[:comment] = split_comment(text) # for mutliple choice we need to strip comments
      
      to_hash
    end
    
    def split_comment answer_text
      reg = Regexp.new('^(.*)#(.*)$', Regexp::MULTILINE)
      matches = reg.match answer_text
      
      return [matches[1].strip, matches[2].strip] if matches
      return [answer_text, nil]
    end
  end
end
