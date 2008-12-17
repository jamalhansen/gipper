require 'answers'
require 'answer_parser'

module Gipper
  class ParsingService
    def parse gift_questions
      gift_questions.strip!

      array = []
      return array if gift_questions.nil?
      
      list = gift_questions.split(/[\r\n][\r\n\t]*[\r\n]/)
      parse_questions list, array
    end
    
    def parse_questions gift_questions, array
      return array if gift_questions.length == 0

      head = gift_questions.first 
      tail = gift_questions[1..gift_questions.length - 1]
      
      question, answer = split_question_from_answer head
      
      parse_questions tail, array_with_added(question, answer, array)
    end
    
    def array_with_added question, answer, in_array
      title, question_text = strip_title(question)
      question_hash = {}
      question_hash[:title] = title
      question_hash[:question] = strip_escapes(question_text)
      question_hash[:answer] = Gipper::Answers.new(answer)
      
      in_array << question_hash
    end
    
    def strip_escapes text
      text.gsub!(/\\~/, '~')
      text.gsub!(/\\=/, '=')
      text.gsub!(/\\#/, '#')
      text.gsub!(/\\\{/, '{')
      text.gsub!(/\\\}/, '}')
      text
    end
     
    def strip_title question
      question.strip!
      
      title = nil
      reg = Regexp.new('^:{2}(.*):{2}(.*)$', Regexp::MULTILINE)
      parts = reg.match question
      
      if parts
        title = parts[1].strip
        question = parts[2]
      end
      
      return [title, question.strip]
    end
    
    def split_question_from_answer text
      text.strip!
      reg = Regexp.new('^([^\{\}]+)\{(.+)\}$', Regexp::MULTILINE)
      matches = reg.match text
      #matches = /^([^\{\}]+)\{(.+)\}$/.match text
      [question = matches[1].strip, question = matches[2].strip]
    end
    
    def question_type text
      question, answer = split_question_from_answer text
      return :true_false if Gipper::TrueFalseAnswerParser.can_parse? answer
      return :multiple_choice if Gipper::AnswerParser.can_parse? answer
    end
  end
end