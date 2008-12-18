module Gipper
  class Answers < Array
    def initialize text, question_post=false
      @question_post = question_post
      parse text
    end
    
    def style
      return :numerical if @numerical
            
      if self.length == 1 && !self[0].has_key?(:text)
        return :true_false
      end
      
      if @question_post
        return :missing_word
      end
      
      if self[0][:correct].class == String
        return :matching
      end
      
      true_count = 0
      self.each do |hash|
        if (hash[:correct] == :true)
          true_count = true_count + 1
        end
      end
      
      if true_count == 1 && self.length > 1
        return :multiple_choice
      else
        return :short_answer
      end
      
    end
    
    private
    def parse answer
      if can_parse_as_true_false? answer
        return (self << extract_true_false_answer_from(answer))
      end

      # => # indicates that this is a numerical answer
      if answer[0] == 35 
        @numerical = true
        
        if !answer.include? "="
          self <<  parse_numerical_clause(answer[1..answer.length])
          return
        end
      end
      
      split_apart answer do |clause|
        if @numerical
          self << parse_numerical_clause(clause) 
        else
          self << parse_clause(clause)
        end
      end
    end
    
    def parse_numerical_clause text
      to_hash = {}
      correct, range = text.split(":", 2)
      range, comment = split_comment range
      correct.gsub!("=", "")
      weight = 100
      
      matches = correct.match(/%(\d+)%(\d+)/)
      if matches
        weight = matches.captures[0].to_i
        correct = matches.captures[1].to_i
      end

      to_hash[:weight] = weight
      to_hash[:comment] = comment
      to_hash[:correct] = correct.to_i
      to_hash[:range] = range.to_i
      to_hash
    end
    
        
    def parse_clause text
      to_hash = {}
      text, to_hash[:correct] = split_correct text
      to_hash[:text], to_hash[:comment] = split_comment(text)

      to_hash
    end
    
    def extract_true_false_answer_from answer
      {:correct => (is_a_true answer), :has_post => false}
    end
    
    def is_a_true answer
      if !(answer.downcase.strip =~ /^(t|true)$/).nil?
        return :true
      end
      
      return :false
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
      text.gsub(/\\(~|=|#|\{|\})/, '\1') if !text.nil?
    end
    
  end
end
