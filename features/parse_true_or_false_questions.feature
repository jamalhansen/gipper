Story: Parsing true or false questions
  As a developer
  I want to parse a file GIFT true or false questions
  So that I can use the data in my application

Scenario: read a file and return an array of questions and answers
  Given a GIFT file of true or false questions 
  When I tell gipper to parse the file
  Then I will get an array of questions and answers