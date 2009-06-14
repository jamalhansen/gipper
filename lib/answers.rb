require 'answer'

module Gipper
  class Answers < Array
    include Oniguruma

    def parse answer
      @answer_text = set_numerical_indicator answer
      parts = split_apart @answer_text

      parts.each do |clause|
        self << Answer.parse(clause, @style_hint)
      end
    end

    def find_style
      return @style_hint if @style_hint

      if self.length == 1 && self[0].text.nil? && boolean?(self[0].correct.class)
        return :true_false
      end

      if self[0].text && self[0].correct.class == String
        return :matching
      end

      if (count_true < 2) && (self.length > 1)
        return :multiple_choice
      else
        return :short_answer
      end
    end


    def boolean? klass
      klass == TrueClass || klass == FalseClass
    end

    def count_true
      true_count = 0
      self.each do |hash|
        if (hash.correct == true)
          true_count = true_count + 1
        end
      end
      true_count
    end

    def set_numerical_indicator answer
      if is_numerical? answer
        @style_hint = :numerical
        answer[1..-1]
      else
        answer
      end
    end

    def is_numerical? answer
      answer[0] == 35
    end
    
    # Iterates through the answer clauses
    def split_apart clauses
      reg = ORegexp.new('(?<!\\\\)(?:[~=])(.(?!(?<!\\\\)[~=]))*', :options => OPTION_MULTILINE)
     
      matches =  reg.scan(clauses)

      # if we didn't find any ~ or = then there is only a single answer
      matches = [clauses] unless matches
      
      matches.map { |m| m.to_s.strip}
    end
  end
end
