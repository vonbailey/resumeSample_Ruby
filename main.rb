load 'rubySampleCode.rb'
load 'utilities.rb'

$se=Scenarios.new
$nc=NegativeCase.new
$mb=CreateSeleniumConnetion.new
$ut=Logging.new
$ut.makeDir
$mb.makeBroswer
$se.nlOfCredit1(1000,35,500,"$514.38")
$se.nlOfCredit2(1000,35,500,200,100,"$411.99")
$driver.navigate.to "http://credit-test.herokuapp.com/"
$se.createCreditLn('alpha','beta')
$nc.validateNegCase
$driver.navigate.to "http://credit-test.herokuapp.com/"
$nc.exceedCrdLmt(2000)  #This does not work.  Cannot find an element to define error in page source.
$driver.close()