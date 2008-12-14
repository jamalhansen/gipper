module Gipper
  class Answers < Array
    def style
      if self.length == 1 && !self[0].has_key?(:text)
        return :true_false
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
    
  end
end
