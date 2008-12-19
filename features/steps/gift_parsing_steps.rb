
Given /^a GIFT file$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. .. spec files super_gift.txt]))
  @data = file.read
  @data.length.should be > 0
end

Then /^contains the correct questions$/ do
  throw "need to implement"
end

