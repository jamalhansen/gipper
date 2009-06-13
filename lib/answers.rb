require 'answer'

module Gipper
  class Answers
    # Parses the answers
    def self.parse answer, style_hint=nil
      array = []

      answers = self.new
      parts = answers.split_apart answer

      parts.each do |clause|
        array << Answer.parse(clause, style_hint) 
      end
      
      array
    end
    
    # Iterates through the answer clauses
    def split_apart clauses
      reg = Regexp.new('.*?(?:[~=])(?!\\\\)', Regexp::MULTILINE)
      
      # need to use reverse since Ruby 1.8 has look ahead, but not look behind
      matches =  clauses.reverse.scan(reg).reverse.map {|clause| clause.strip.reverse}

      # if we didn't find any ~ or = then there is only a single answer
      matches = [clauses] if(matches.length == 0)
      
      matches
    end
  end
end
