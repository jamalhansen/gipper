require 'answers'
require 'question'

module Gipper
  class Quiz < Array
    def self.parse gift_questions
      quiz = Quiz.new(gift_questions.strip)
    end
    
    private
    def initialize quiz
      iterate_through quiz do |question|
        self << Gipper::Question.parse(question)
      end
    end
      
    def iterate_through questions
      questions.gsub! /^\s*\\.*$/, ""  # strip out comment lines
      
      list = questions.split(/[\r\n][\r\n\t]*[\r\n]/)
      
      list.each do |item|
        yield item
      end
    end
  end
end