require 'multiple_choice_answer'
require 'true_false_answer_parser'
require 'multiple_choice_answer_parser'

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
        return parse_questions(tail, array)
      end
      
      parse_questions tail, array_with_added(question, answer, array)
    end
    
    def array_with_added question, answer, in_array
      title, question_text = strip_title(question)
      
      question_hash = {}
      question_hash[:title] = title
      question_hash[:question] = question_text
      
      

      in_array << (question_hash.merge(parse_answer(answer)))
    end
    
    def strip_title question
      title = nil
      reg = Regexp.new(':{2}([^:{2}]+):{2}(.*)', Regexp::MULTILINE)
      parts = reg.match question
      
      if parts
        title = parts[1].strip
        question = parts[2]
      end
      
      return [title, question.strip]
    end
    
    def split_question_from_answer text
      matches = /^([^(\{|\})]+)\{([^(\{|\})]+)\}/.match text
      [question = matches[1].strip, question = matches[2].strip]
    end
    
    def question_type text
      question, answer = split_question_from_answer text
      return :true_false if Gipper::TrueFalseAnswerParser.can_parse? answer
      return :multiple_choice if Gipper::MultipleChoiceAnswerParser.can_parse? answer
    end
    
    def parse_answer text
      if Gipper::MultipleChoiceAnswerParser.can_parse? text
        answer_parser = Gipper::MultipleChoiceAnswerParser.new
        answer = answer_parser.parse text
      end
      
      if Gipper::TrueFalseAnswerParser.can_parse? text
        answer_parser = Gipper::TrueFalseAnswerParser.new
        answer = answer_parser.parse text
      end
      
      answer
    end
  end
end