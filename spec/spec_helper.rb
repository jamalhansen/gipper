begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'gipper'

def true_false_question title, question, answer
  if title
    "::#{title}::#{question}#{answer}"
  else
    "#{question}#{answer}"
  end
end