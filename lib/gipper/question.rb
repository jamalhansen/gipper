module Gipper
  class Question
    def self.parse text
      Question.new text
    end
   
    attr_reader :text_post, :answer, :title, :text, :style
    
    private
    def initialize text
      reg = Regexp.new('(.*)\}(?!\\\\)(.+)\{(?!\\\\)(.+)', Regexp::MULTILINE)
      matches = text.strip.reverse.match(reg).captures.map { |s| s.strip.reverse }
      
      @text_post = strip_escapes(matches[0]) if !matches[0].empty?
      @answer = Gipper::Answers.new(matches[1], !@text_post.nil?)
      @title, question = strip_title(matches[2])
      @text = strip_escapes(question)
      @style = find_style
    end
    
    def find_style
      return :numerical if @answer.numerical
            
      if @answer.length == 1 && @answer[0].text.nil?
        return :true_false
      end
      
      if @text_post
        return :missing_word
      end
      
      if @answer[0].correct.class == String
        return :matching
      end
      
      true_count = 0
      @answer.each do |hash|
        if (hash.correct == :true)
          true_count = true_count + 1
        end
      end
      
      if true_count == 1 && @answer.length > 1
        return :multiple_choice
      else
        return :short_answer
      end
      
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

