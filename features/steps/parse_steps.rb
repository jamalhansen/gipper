require File.join(File.dirname(__FILE__), *%w[.. .. spec spec_helper.rb])

Given(/^a GIFT file of true or false questions$/) do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. .. spec files true_or_false.gift]))
  @data = file.read
  @data.length.should be > 0
end

When(/^I tell gipper to parse the file$/)do
  parser = Gipper::Parser.new
  @questions = parser.parse(@data)
end

Then(/^I will get an array of questions and answers$/)do
  @questions.class == Array
  @questions[0][:style].should eql(:true_false)
  @questions[0][:question].should eql("Monkeys like to fly like ninjas.")
  @questions[0][:title].should eql("TrueStatement about monkeys")
  @questions[0][:answer].should eql(true)
  
  @questions[1][:style].should eql(:true_false)
  @questions[1][:question].should eql("Monkeys roam in packs with swords.")
  @questions[1][:title].should eql("A Second TrueStatement about monkeys")
  @questions[1][:answer].should eql(true)
end
