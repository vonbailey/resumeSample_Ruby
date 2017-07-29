load 'rubySampleCode.rb'
load 'utilities.rb'

se=Scenarios.new
nc=NegativeCase.new
ut=Logging.new
ut.makeDir
se.makeBroswer
se.nlOfCredit1(1000,35,500,"$514.38")
se.nlOfCredit2(1000,35,500,200,100,"$411.99")
$driver.navigate.to "http://credit-test.herokuapp.com/"
se.createCreditLn('alpha','beta')
nc.validateNegCase
$driver.close()