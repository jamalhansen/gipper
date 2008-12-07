begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

#$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__) + '/../lib/gipper')
require 'parser'

def is_true string
  string == "{T}" || string == "{True}"
end

def true_false_question title, question, answer
  if title
    "::#{title}::#{question}#{answer}"
  else
    "#{question}#{answer}"
  end
end