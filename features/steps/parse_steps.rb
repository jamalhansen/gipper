require File.join(File.dirname(__FILE__), *%w[.. .. spec spec_helper.rb])

When(/^I tell gipper to parse the file$/)do
  parser = Gipper::Parser.new
  @questions = parser.parse(@data)
end

Then(/^I will get an array of questions and answers$/)do
  @questions.class.should eql(Array)
end
