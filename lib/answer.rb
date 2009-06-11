module Gipper
  class Answer
    attr_reader :weight, :correct, :comment, :range, :text
    
    def self.parse text, style_hint = nil
      answer = Answer.new
      answer.read text, style_hint
      answer
    end
        
    def can_parse_as_true_false? answer
      return false if answer.nil?
      answer.downcase.strip =~ /^(t|f|true|false)$/
    end

    def read answer, style_hint
      case style_hint
      when :numerical
        correct, range = answer.split(":", 2)
        range, comment = split_comment range
        correct.gsub!("=", "")
        weight = 100

        correct, weight = split_weight(correct)
        @weight = weight.to_i if weight
        
        @comment = comment
        parts = correct.split(/\.\./)
        if parts.length == 2
          parts.map! { |s| to_num(s) }
          @correct = ((parts[0] + parts[1]) /2)
          @range = ((parts[1] - parts[0]) /2)
        else
          @correct = to_num(correct)
          @range = to_num(range)
        end
      else
        correct, text = split_correct answer

        split_matching(text) do |t, c|
          text, correct = t, c       
        end

        text, weight = split_weight(text)
        @weight = weight.to_i if weight
        @text, @comment = split_comment(text)  
        @correct = correct
        
        # handle true false
        if can_parse_as_true_false?(@text)
          convert_to_true_false!
        end
      end
    end
    
    def convert_to_true_false!
      @correct = is_true(@text)
      @text = nil
    end
    
    def to_num(val)
      if val && val.include?(".")
        val.to_f
      else
        val.to_i
      end
    end
    
    def is_true answer
      !(answer.downcase.strip =~ /^(t|true)$/).nil?
    end
    
    def split_correct clause
      correct = []
      
      if clause =~ /^[~=]/
        correct[0] = eval_correctness(clause[0])
        correct[1] = clause[1..clause.length].strip
      else
        correct[0] = true
        correct[1] = clause
      end
      
      return correct
    end
    
    def split_matching answers
      reg = Regexp.new('(.*)\-\>(.*)', Regexp::MULTILINE)
      matches = reg.match answers
      
      if matches
        yield matches.captures.map {|s| s.strip}
      end
    end
    
    def split_weight answer
      return [answer, nil] unless answer.class == String
      matches = answer.match(/%(-?\d+)%(.+)/)
      if matches
        weight = matches.captures[0]
        correct = matches.captures[1]
        return [correct, weight]
      end
        
      return [answer, nil]  
    end

    def eval_correctness indicator
      { 61 => true, 126 => false}[indicator]
    end
    
    def split_comment answer_text
      return [nil, nil] if blank?(answer_text)

      answer_text.strip!
      reg = Regexp.new('#(?!\\\\)', Regexp::MULTILINE)
      text, feedback_comment = answer_text.reverse.split(reg, 2).map {|ss| ss.reverse.strip}.reverse
      text = strip_escapes(text)
      feedback_comment = strip_escapes(feedback_comment) if feedback_comment
      [text, feedback_comment]
    end
    
    def strip_escapes text
      text.gsub(/\\\\(~|=|#|\{|\})/, '\1') if !text.nil?
    end

    def blank? text
      text.nil? || text == ""
    end
  end
end
  
