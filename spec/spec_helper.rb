begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib/gipper')
require 'parsing_service'

def is_true answer
  !(answer.downcase.strip =~ /^(t|true)$/).nil?
end

def true_false_question title, question, answer
  if title
    "::#{title}::#{question}#{answer}"
  else
    "#{question}#{answer}"
  end
end