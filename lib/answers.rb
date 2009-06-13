require 'answer'

module Gipper
  class Answers
    include Oniguruma
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
      reg = ORegexp.new('(?<!\\\\)(?:[~=])(.(?!(?<!\\\\)[~=]))*', :options => OPTION_MULTILINE)
     
      matches =  reg.scan(clauses)

      # if we didn't find any ~ or = then there is only a single answer
      matches = [clauses] unless matches
      
      matches.map { |m| m.to_s.strip}
    end
  end
end
