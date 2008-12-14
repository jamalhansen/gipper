Story: Parsing short answer questions
  As a developer
  I want to parse a GIFT file containing short answer questions
  So that I can use the data in my application

Scenario: read a file and return an array of questions and answers
  Given a GIFT file of short answer questions 
  When I tell gipper to parse the file
  Then I will get an array of questions and answers
  And contains the correct short answer questions
