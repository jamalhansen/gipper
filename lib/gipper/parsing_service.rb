require 'answers'

module Gipper
  class ParsingService
    def parse gift_questions
      gift_questions.strip!

      array = []
      
      iterate_through gift_questions do |question|
        question, answer = split_question_from_answer question
        array << format_both(question, answer)
      end
      
      array
    end
    
    def iterate_through questions
      list = questions.split(/[\r\n][\r\n\t]*[\r\n]/)
      
      list.each do |item|
        yield item
      end
    end
    
    def format_both question, answer
      title, question_text = strip_title(question)
      question_hash = {}
      question_hash[:title] = title
      question_hash[:question] = strip_escapes(question_text)
      question_hash[:answer] = Gipper::Answers.new(answer)
      
      question_hash
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

      [question = matches[1].strip, question = matches[2].strip]
    end
    
    def question_type text
      question, answer = split_question_from_answer text
      return :true_false if Gipper::TrueFalseAnswerParser.can_parse? answer
      return :multiple_choice if Gipper::AnswerParser.can_parse? answer
    end
  end
end