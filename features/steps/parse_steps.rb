require File.join(File.dirname(__FILE__), *%w[.. .. spec spec_helper.rb])

When(/^I tell gipper to parse the file$/)do
  service = Gipper::ParsingService.new
  @questions = service.parse(@data)
end

Then(/^I will get an array of questions and answers$/)do
  @questions.class.should eql(Array)
end
