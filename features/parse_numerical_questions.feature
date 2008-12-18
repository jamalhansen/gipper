Story: Parsing numerical questions
  As a developer
  I want to parse a GIFT file containing numerical questions
  So that I can use the data in my application

Scenario: read a file and return an array of questions and answers
  Given a GIFT file of numerical questions 
  When I tell gipper to parse the file
  Then I will get an array of questions and answers
  And contains the correct numerical questions
