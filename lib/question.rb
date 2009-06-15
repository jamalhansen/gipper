require 'special_charater_handler'

module Gipper
  class Question
    include Oniguruma
    include Gipper::SpecialCharacterHandler
    
    attr_accessor :text_post, :answer, :title, :text, :style, :format
    
    # instance method to parse the question
    def parse text
      reg = ORegexp.new('(.+)(?<!\\\\)\{(?<!\\\\)(.+)\}(.*)', :options => OPTION_MULTILINE)
      matches = reg.match(text.strip).captures.map { |s| s.strip }

      @text_post = unescape(matches[2]) unless matches[2].empty?
      
      answer = matches[1]

      @answer = Gipper::Answers.new
      @answer.parse(answer)

      @format, @title, @text = to_parts(matches[0]).map { |s| unescape s}

      @style = find_style @answer
    end

    def find_style answers
      if @text_post
        return :missing_word
      end

      answers.find_style
    end

    private
      def to_parts question
        format_part = '(\[(?<format>(.*))\])'
        title_part = '(:{2}(?<title>(.*)):{2})'
        question_part = '(?<question>(.*))'
        whole_regex = "^#{format_part}?\\s*#{title_part}?\\s*#{question_part}$"

        reg = ORegexp.new(whole_regex, :options => OPTION_MULTILINE)
        parts = reg.match(question.strip)

        format = parts[:format].strip if parts[:format]
        title = parts[:title].strip if parts[:title]
        question = parts[:question].strip

        return [format, title, question]
      end
  end
end

