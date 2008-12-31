require 'answers'
require 'question'

module Gipper
  class Quiz
    def self.parse gift_file
      quiz = Quiz.new()
      gift = []
      gift_file.strip!
      
      quiz.iterate_through gift_file do |question|
        gift << Gipper::Question.parse(question)
      end
      
      gift
    end
    
    def iterate_through questions
      questions.gsub!(/^\s*\/\/.*$/, "")  # strip out comment lines
      
      list = questions.split(/[\r\n][\r\n\t]*[\r\n]/)
      list.each do |item|
        if item != ''
          yield item 
        end
      end
    end
  end
end