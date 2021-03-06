require 'answers'
require 'question'

module Gipper
  class Quiz
    def self.parse gift_file
      quiz = Quiz.new()
      gift = []
      gift_file.strip!
      
      quiz.iterate_through gift_file do |question|
        q = Gipper::Question.new
        q.parse(question)
        gift << q
      end
      
      gift
    end
    
    def iterate_through questions
      questions.gsub!(/^\s*\/\/.*$/, "")  # strip out comment lines
      
      list = questions.split(/[\r\n][\r\n\t\s]*[\r\n]/)
      list.each do |item|
        if item != ''
          yield item 
        end
      end
    end
  end
end