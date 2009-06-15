require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'custom_assertions'
require 'gipper'

class Test::Unit::TestCase
  include CustomAssertions
  def true_false_question title, question, answer
    if title
      "::#{title}::#{question}#{answer}"
    else
      "#{question}#{answer}"
    end
  end
end
