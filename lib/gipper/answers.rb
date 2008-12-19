require 'answer'

module Gipper
  class Answers < Array
    def initialize text, question_post=false
      @question_post = question_post
      parse text
    end

    attr_reader :numerical
    
    private
    def parse answer
     
      
      # => # indicates that this is a numerical answer
      if answer[0] == 35 
        @numerical = true
        answer = answer[1..answer.length]
      end

      split_apart answer do |clause|
        if @numerical
          self << Answer.new(clause, :numerical) 
        else
          self << Answer.new(clause)
        end
      end
    end
    
    # Iterates through the answer clauses
    def split_apart clauses
      reg = Regexp.new('.*?(?:[~=])(?!\\\\)', Regexp::MULTILINE)
      
      # need to use reverse since Ruby 1.8 has look ahead, but not look behind
      matches =  clauses.reverse.scan(reg).reverse.map {|clause| clause.strip.reverse}

      # if we didn't find any ~ or = then there is only a single answer
      matches = [clauses] if(matches.length == 0)
      
      matches.each do |match|
        yield match
      end
    end
  end
end
