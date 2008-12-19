module Gipper
  class Answer
    attr_reader :weight, :correct, :comment, :range, :text
    
    def initialize text, style_hint = nil
      case style_hint
      when :numerical
        parse_numerical text
      else
        parse text
      end
      
    end
    
    private
    def parse_numerical text
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

      @weight = weight
      @comment = comment
      @correct = correct.to_i
      @range = range.to_i
     end
    
     def parse answer
      if can_parse_as_true_false? answer
        @correct = is_a_true answer
        @has_post = false
      else
        text, @correct = split_correct answer
        @text, @comment = split_comment(text)       
      end
    end
    
    def can_parse_as_true_false? answer
      return false if answer.nil?

      !(answer.downcase.strip =~ /^(t|f|true|false)$/).nil?
    end
    
    def is_a_true answer
      if !(answer.downcase.strip =~ /^(t|true)$/).nil?
        return :true
      end
      
      return :false
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
  
