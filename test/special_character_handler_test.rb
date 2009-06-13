require 'test_helper'

class SpecialCharacterHandlerTest < Test::Unit::TestCase
  include Gipper::SpecialCharacterHandler

  context "striping escapes" do
    should "leave normal text alone" do
      result = unescape("This is some normal text.")
      assert_equal "This is some normal text.", result
    end

    #(~|=|#|\{|\})
    should "remove escape from escaped twiddles" do
      result = unescape("This is some twiddled \\~ text.")
      assert_equal "This is some twiddled ~ text.", result
    end

    should "remove escape from escaped equals" do
      result = unescape("This is some equaled \\= text.")
      assert_equal "This is some equaled = text.", result
    end

    should "remove escape from escaped pounded" do
      result = unescape("This is some pounded \\# text.")
      assert_equal "This is some pounded # text.", result
    end

    should "remove escape from escaped left brackets" do
      result = unescape("This is some left bracketed \\{ text.")
      assert_equal "This is some left bracketed { text.", result
    end

    should "remove escape from escaped right brackets" do
      result = unescape("This is some right bracketed \\} text.")
      assert_equal "This is some right bracketed } text.", result
    end

    should "not remove escapes from other characters" do
      result = unescape("\\This \\is \\some \\normal \\text\\.")
      assert_equal "\\This \\is \\some \\normal \\text\\.", result
    end
  end
end
