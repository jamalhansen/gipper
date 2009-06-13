begin
  require 'oniguruma'
rescue LoadError
  require 'rubygems'
  require 'oniguruma'
end

require 'answer'
require 'answers'
require 'question'
require 'quiz'

module Gipper

end