module Gipper
  class ParsingService
    def parse gift_questions
      array = []
      return array if gift_questions.nil?
      
      list = gift_questions.split(/[\r\n][\r\n\t]*[\r\n]/)
      parse_questions list, array
    end
    
    def parse_questions gift_questions, array
      return array if gift_questions.length == 0
      
      head = gift_questions.first 
      tail = gift_questions[1..gift_questions.length - 1]
      
      begin
        question, answer = split_question_from_answer head
      rescue
        #we weren't able to parse the question, so move on to the next one
        return parse_questions tail, array
      end
      
      parse_questions tail, array_with_added(question, answer, array)
    end
    
    def array_with_added question, answer, in_array
      title, question_text = strip_title(question)
      
      question_hash = {}
      question_hash[:title] = title
      question_hash[:question] = question_text
      
      if is_a_multiple_choice answer
        question_hash[:answer] = is_a_true answer
        question_hash[:style] = :multiple_choice
      end
      
      if is_a_true_false answer
        question_hash[:answer] = is_a_true answer
        question_hash[:style] = :true_false 
      end

      in_array << question_hash
    end
    
    def strip_title question
      parts = /:{2}([^:{2}]+):{2}([^:{2}]+)/.match question
      if parts
        return [parts[1].strip, parts[2].strip]
      end
      
      return [nil, question]
    end
    
    def is_a_true answer
      !(answer.downcase.strip =~ /^(t|true)$/).nil?
    end
    
    def is_a_true_false answer
      return false if answer.nil?

      answer.downcase.strip =~ /(t|f|true|false)/
    end

    def split_question_from_answer text
      matches = /^([^(\{|\})]+)\{([^(\{|\})]+)\}/.match text
      [question = matches[1].strip, question = matches[2].strip]
    end
    
    def question_type text
      question, answer = split_question_from_answer text
      return :true_false if is_a_true_false answer
      return :multiple_choice if is_a_multiple_choice answer
    end
        
    def is_a_multiple_choice answer
      answer.downcase.strip =~ /^((~|=)[^(~|=)]+)+$/
    end
    
  end
end