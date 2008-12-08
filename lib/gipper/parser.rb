module Gipper
  class Parser
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
      
      matches = /^([^(\{|\})]+)\{([^(\{|\})]+)\}/.match head
      parse_questions tail, array_with_added(matches, array)
    end
    
    def array_with_added matches, in_array
      return in_array if !matches
      
      question = matches[1].strip
      answer = matches[2].strip
      title, question_text = strip_title(question)

      ## for testing
      #puts "\r\n\r\n"
      #puts question
      #puts answer
      #puts title
      #puts question_text
      
      question_hash = {}
      question_hash[:style] = :true_false
      question_hash[:title] = title
      question_hash[:question] = question_text
      question_hash[:answer] = is_a_true answer

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
      !(answer =~ /(t|T|True|true)/).nil?
    end
  end
end