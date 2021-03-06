require 'special_charater_handler'

module Gipper
  # == Gipper::Answer
  # 
  # Represents the single correct answer if there is only one answer,
  # or one of the answer choices if multiple are provided for a question.
  #
  # To populate the answer from a string use the parse method
  #
  #   answer = Gipper::Answer.new
  #   answer.parse "= foo #bar"
  #
  #   answer.correct
  #   >> true
  #
  #   answer.text
  #   >> foo
  #
  #   answer.comment
  #   >> bar
  #
  # or 
  #
  #   answer.parse "F"
  #
  #   answer.correct
  #   >> false
  #
  class Answer
    include Oniguruma
    include Gipper::SpecialCharacterHandler
    attr_reader :weight, :correct, :comment, :range, :text

    # Will parse a single answer into it's parts.
    # If the answer type is numerical, pass :numerical as the optional second parameter.
    def parse answer, style_hint = nil
      if style_hint == :numerical
        parse_as_numerical answer
      else
        parse_standard answer
      end
    end

    private
      def can_parse_as_true_false? answer
        return false if answer.nil?
        answer.downcase.strip =~ /^(t|f|true|false)$/
      end

      def parse_standard answer
        correct, text = split_correct answer

        split_matching(text) do |t, c|
          text, correct = t, c
        end

        text, weight = split_weight(text)
        @weight = weight.to_i if weight
        @text, @comment = split_comment(text).map { |item| unescape item }

        @correct = correct

        # handle true false
        if can_parse_as_true_false?(@text)
          convert_to_true_false!
        end
      end

      def parse_as_numerical answer
        correct, range = answer.split(":", 2)
        range, comment = split_comment range
        correct.gsub!("=", "")
        weight = 100

        correct, weight = split_weight(correct)
        @weight = weight.to_i if weight

        @comment = comment
        parts = correct.split(/\.\./)
        if parts.length == 2
          parts.map! { |s| to_num(s) }
          @correct = ((parts[0] + parts[1]) /2)
          @range = ((parts[1] - parts[0]) /2)
        else
          @correct = to_num(correct)
          @range = to_num(range)
        end
      end

      def convert_to_true_false!
        @correct = is_true(@text)
        @text = nil
      end

      def to_num(val)
        if val && val.include?(".")
          val.to_f
        else
          val.to_i
        end
      end

      def is_true answer
        !(answer.downcase.strip =~ /^(t|true)$/).nil?
      end

      def split_correct clause
        correct = []

        if clause =~ /^[~=]/
          correct[0] = eval_correctness(clause[0])
          correct[1] = clause[1..clause.length].strip
        else
          correct[0] = true
          correct[1] = clause
        end

        return correct
      end

      def split_matching answers
        reg = Regexp.new('(.*)\-\>(.*)', Regexp::MULTILINE)
        matches = reg.match answers

        if matches
          yield matches.captures.map {|s| s.strip}
        end
      end

      def split_weight answer
        return [answer, nil] unless answer.class == String
        matches = answer.match(/%(-?\d+)%(.+)/)
        if matches
          weight = matches.captures[0]
          correct = matches.captures[1]
          return [correct, weight]
        end

        return [answer, nil]
      end

      def eval_correctness indicator
        { 61 => true, 126 => false}[indicator]
      end

      def split_comment answer_text
        return [nil, nil] if blank?(answer_text)

        answer_text.strip!
        reg = ORegexp.new('(?<before>.*)(?<!\\\\)#(?<after>.*)', :options => OPTION_MULTILINE)
        match = reg.match(answer_text)
        return [answer_text, nil] unless match

        text = match[:before].strip
        feedback_comment = match[:after].strip
        [text, feedback_comment]
      end

      def blank? text
        text.nil? || text == ""
      end
  end
end
  
