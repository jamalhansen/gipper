module Gipper
  module SpecialCharacterHandler
    protected
      def unescape text
        text.gsub(/\\(~|=|#|\{|\})/, '\1') if !text.nil?
      end
  end
end
