Given /^a GIFT file of numerical questions$/ do
  file = File.open(File.join(File.dirname(__FILE__), *%w[.. .. spec files numerical.gift]))
  @data = file.read
  @data.length.should be > 0
end

Then /^contains the correct numerical questions$/ do
  @questions.length.should be(2)
  
  #When was Harvey D. Smith born?{#1945:5}
  @questions[0][:answer].style.should eql(:numerical)
  @questions[0][:question].should eql("When was Harvey D. Smith born?")
  @questions[0][:title].should eql(nil)
  @questions[0][:answer].length.should eql(1)
  @questions[0][:answer][0][:correct].should eql(1945)
  @questions[0][:answer][0][:range].should eql(5)
  @questions[0][:answer][0][:weight].should eql(100)
  
  #//this comment will be ignored in the import process 
  #::Numerical example::
  #When was Elizabeth M. Danson born? {#
  #    =1993:0      #Correct!  you will get full credit for this answer
  #    =%50%1993:2  #She was born in 1993.
  #                 You get 50% credit for being close.
  #}
  @questions[1][:answer].style.should eql(:numerical)
  @questions[1][:question].should eql("When was Elizabeth M. Danson born?")
  @questions[1][:title].should eql("Numerical example")
  @questions[1][:answer].length.should eql(2)
  @questions[1][:answer][0][:correct].should eql(1993)
  @questions[1][:answer][0][:range].should eql(0)
  @questions[1][:answer][0][:weight].should eql(100)
  @questions[1][:answer][0][:comment].should eql("Correct!  you will get full credit for this answer")
  @questions[1][:answer][1][:correct].should eql(1993)
  @questions[1][:answer][1][:range].should eql(2)
  @questions[1][:answer][1][:weight].should eql(50)
  @questions[1][:answer][1][:comment].should eql("She was born in 1993.
                 You get 50% credit for being close.")
  
end

