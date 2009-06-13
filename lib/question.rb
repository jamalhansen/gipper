require 'special_charater_handler'

module Gipper
  class Question
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
      reg = Regexp.new('(.*)\}(?!\\\\)(.+)\{(?!\\\\)(.+)', Regexp::MULTILINE)
      matches = text.strip.reverse.match(reg).captures.map { |s| s.strip.reverse }
      
      @text_post = unescape(matches[0]) if !matches[0].empty?
      
      answer = matches[1]
      @style_hint = nil
      if answer[0] == 35 
        @style_hint = :numerical
        answer = answer[1..answer.length]
      end
      
      @answer = Gipper::Answers.parse(answer, @style_hint)
      @title, question = strip_title(matches[2])
      @format, question = strip_format(question)
      @text = unescape(question)
      @style = find_style
    end
    
    def find_style
      return @style_hint if @style_hint
            
      if @answer.length == 1 && @answer[0].text.nil? && boolean?(@answer[0].correct.class)
        return :true_false
      end
            
      if @text_post
        return :missing_word
      end
        
      if @answer[0].text && @answer[0].correct.class == String 
        return :matching
      end
      
      true_count = 0
      @answer.each do |hash|
        if (hash.correct == true)
          true_count = true_count + 1
        end
      end
          
      if true_count <= 1 && @answer.length > 1
        return :multiple_choice
      else
        return :short_answer
      end
      
    end
    
    def boolean? klass
      klass == TrueClass || klass == FalseClass
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

