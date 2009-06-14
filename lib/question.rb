require 'special_charater_handler'

module Gipper
  class Question
    include Oniguruma
    include Gipper::SpecialCharacterHandler
    # Parses a single question and returns an instance of itself with the data
    def self.parse text
      question = Question.new
      question.read text
      question
    end
   
    
    attr_accessor :text_post, :answer, :title, :text, :style, :format
    
    # instance method to parse the question
    def read text
      reg = ORegexp.new('(.+)(?<!\\\\)\{(?<!\\\\)(.+)\}(.*)', :options => OPTION_MULTILINE)
      matches = reg.match(text.strip).captures.map { |s| s.strip }

      @text_post = unescape(matches[2]) unless matches[2].empty?
      
      answer = matches[1]

      @answer = Gipper::Answers.new
      @answer.parse(answer)
      
      @title, question = strip_title(matches[0])
      @format, question = strip_format(question)
      @text = unescape(question)
      @style = find_style @answer
    end

    def find_style answers
      if @text_post
        return :missing_word
      end

      answers.find_style
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

    def strip_format question
      reg = Regexp.new('^\[(.*)\](.*)$', Regexp::MULTILINE)      
      parts = reg.match(question.strip)            
      
      if parts        
        title = parts.captures[0].strip        
        question = parts.captures[1]      
      end            
     
      return [title, question.strip]
    end
  end
end

