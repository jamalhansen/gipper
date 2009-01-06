module Gipper
  class Answer
    attr_reader :weight, :correct, :comment, :range, :text
    
    def self.parse text, style_hint = nil
      style_hint = :true_false if !style_hint && can_parse_as_true_false?(text)
      
      answer = Answer.new
      answer.read text, style_hint
      answer
    end
        
    def self.can_parse_as_true_false? answer
      return false if answer.nil?

      !(answer.downcase.strip =~ /^(t|f|true|false)$/).nil?
    end

    def read answer, style_hint
      case style_hint
      when :true_false
        @correct = is_a_true answer
      when :numerical
        correct, range = answer.split(":", 2)
        range, comment = split_comment range
        correct.gsub!("=", "")
        weight = 100

        matches = correct.match(/%(\d+)%(\d+)/)
        if matches
          weight = matches.captures[0]
          correct = matches.captures[1]
        end

        @comment = comment
        @weight = weight.to_i
        
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

        @text, @comment = split_comment(text)  
        
        @correct = correct
      end
    end
    
    def to_num(val)
      if val && val.include?(".")
        val.to_f
      else
        val.to_i
      end
    end
    
    def is_a_true answer
      if !(answer.downcase.strip =~ /^(t|true)$/).nil?
        return true
      end
      
      return false
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

    def eval_correctness indicator
      { 61 => true, 126 => false}[indicator]
    end
    
    def split_comment answer_text
      return [nil, nil] if answer_text.nil? || answer_text == ""
      
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
  
