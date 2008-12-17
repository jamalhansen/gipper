module Gipper
  class AnswerParser
    def parse answer, answers
      if can_parse_as_true_false? answer
        return (answers << extract_true_false_answer_from(answer))
      end

      split_apart answer do |clause|
        obj = {}
        parse_clause clause, obj
        answers << obj
      end
      
      answers
    end
    
    def extract_true_false_answer_from answer
      {:correct => (is_a_true answer)}
    end
    
    def is_a_true answer
      if !(answer.downcase.strip =~ /^(t|true)$/).nil?
        return :true
      end
      
      return :false
    end
    
    def can_parse? text
      return false if text.nil?
      !(text.strip =~ /^([~=]([^~=]|\\[~=])+)+$/).nil?
    end
    
    def can_parse_as_true_false? answer
      return false if answer.nil?

      !(answer.downcase.strip =~ /^(t|f|true|false)$/).nil?
    end
    
    # Iterates through the answer clauses
    def split_apart clauses
      reg = Regexp.new('.*?(?:[~=])(?!\\\\)', Regexp::MULTILINE)
      
      # need to use reverse since Ruby 1.8 has look ahead, but not look behind
      matches =  clauses.reverse.scan(reg).reverse.map {|clause| clause.strip.reverse}

      matches.each do |match|
        yield match
      end
    end

    def split_correct clause
      # need to strip first character before regex
      correct, rest  = clause.split(//, 2)   
      
      reg = Regexp.new('(.*)\-\>(.*)', Regexp::MULTILINE)
      matches = reg.match rest
 
      if matches
        text = matches[1].strip
        correct_answer = matches[2].strip 

        return [text, correct_answer]
      end

      correct_answer = eval_correctness correct
      return [rest.strip, correct_answer]
    end
    
    def eval_correctness indicator
      return :true if indicator == "="
      return :false
    end
    
    def parse_clause text, to_hash

      puts text
      
      text, to_hash[:correct] = split_correct text
      to_hash[:text], to_hash[:comment] = split_comment(text)

      puts to_hash.inspect
      to_hash
    end
    
    def split_comment answer_text

      reg = Regexp.new('#(?!\\\\)', Regexp::MULTILINE)
      matches = answer_text.reverse.split(reg).map {|ss| ss.reverse} 
      
      if matches.length > 1
        comment = matches[0].strip
        text = matches[1].strip
      else
        text = matches[0].strip
      end
    
      return [strip_escapes(text), comment]
    end
    
    def strip_escapes text
      text.gsub!(/\\~/, '~')
      text.gsub!(/\\=/, '=')
      text.gsub!(/\\#/, '#')
      text.gsub!(/\\\{/, '{')
      text.gsub!(/\\\}/, '}')
      text
     end
  end
end
