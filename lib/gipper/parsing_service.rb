require 'answers'

module Gipper
  class ParsingService
    def parse gift_questions
      gift_questions.strip!

      array = []
      
      iterate_through gift_questions do |question|
        array << write_question(question)
      end
      
      array
    end
    
    def iterate_through questions
      list = questions.split(/[\r\n][\r\n\t]*[\r\n]/)
      
      list.each do |item|
        yield item
      end
    end
    
    def write_question text
      values = {:question_post => nil}
      
      reg = Regexp.new('(.*)\}(?!\\\\)(.+)\{(?!\\\\)(.+)', Regexp::MULTILINE)
      matches = text.strip.reverse.match(reg).captures.map { |s| s.strip.reverse }
      
      values[:question_post] = strip_escapes(matches[0]) if !matches[0].empty?
      values[:answer] = Gipper::Answers.new(matches[1], !values[:question_post].nil?)
      values[:title], question = strip_title(matches[2])
      values[:question] = strip_escapes(question)
      
      values
    end
    
    def strip_escapes text
      text.gsub(/\\(~|=|#|\{|\})/, '\1') if !text.nil?
    end
     
    def strip_title question
      reg = Regexp.new('^:{2}(.*):{2}(.*)$', Regexp::MULTILINE)      
      parts = reg.match(question.strip)            
      
      if parts        
        title = parts.captures[0].strip        
        question = parts.captures[1]      
      end            
     
      return [title, question.strip]
    end
  end
end