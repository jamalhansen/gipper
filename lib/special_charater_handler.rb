module Gipper
  module SpecialCharacterHandler
    def unescape text
      text.gsub(/\\(~|=|#|\{|\})/, '\1') if !text.nil?
    end
  end
end
