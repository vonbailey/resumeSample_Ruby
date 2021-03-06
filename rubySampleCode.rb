
require 'selenium-webdriver'
load 'utilities.rb'



class Scenarios

  def verifyContent(x,y)
    begin
      if(y.include? x)
        $log.logThis("Correct Amount of interest discovered.")
        return true
      else
        $log.logThis("Incorrect Amount of interest discovered.")
        return false
      end
    rescue
      $log.processError('ERROR-verifyContent')
    end     
  end
  
  def createCreditLn(crdLmt,creAPR)
    # Clicking on "New Line Of Credit" link 
    begin
      nLineCrd=$driver.find_element(:link_text, "New Line of credit").click()
      $wait
    rescue
      $log..processError('ERROR-Clicking_New_Line_Of_Credit_Button')
    end
    # Entering Transaction values
    begin
      $driver.find_element(:id, "line_of_credit_apr").send_keys(creAPR)
      $driver.find_element(:id, "line_of_credit_credit_limit").send_keys(crdLmt)
      $driver.save_screenshot($dir+'/'+'enteringTransactionValues.png')
    rescue
      $log.processError('ERROR-enteringTransactionValues')
    end
    # Submitting new values
    begin
      $driver.find_element(:name, "commit").click()
      $wait
    rescue
      $log.processError('ERROR-submittingTransactionsValues')
    end 
  end

  def nlOfCredit1(crdLmt,creAPR,draw,intAmt)
    createCreditLn(crdLmt,creAPR)
    source=$driver.page_source
    search="Line of credit was successfully created."
    begin
      valid=verifyContent(search,source)
      if(valid==true)
        begin
          $log.logThis("Adding 500 Dollar Draw")
          $driver.find_element(:name, "transaction[amount]").send_keys(draw)
          $driver.save_screenshot($dir+'/'+'Entered_500_Draw.png')
          $log.logThis("Successfully entered transaction amount!")
        rescue
          $log.processError('ERROR-Failed_entering_credit_draw_s1')
          return
        end
      else
        $log.processError('ERROR-In_creditline_data_s1')
        return
      end
    rescue
      $log.processError('ERROR-Failed_to_validate_new_creditline_s1')
      return
    end
    begin
      $driver.find_element(:name, "commit").click()
      $wait
    rescue
      $log.processError('ERROR-submitting_transaction')
      return
    end
    # Verifying the final interest was calcuated correctly
    begin
      source=$driver.page_source
      valid=verifyContent(intAmt,source)
      if(valid==true)
        $log.logThis("Successfully calculated the interest for Scenario 1")
        $driver.save_screenshot($dir+'/'+'PASSED-calculated_interest.png')
      else
        $log.processError('ERROR-FAILED-SCENARIO_1_COMPLETED')
        return
      end
    rescue
      $log.processError('ERROR-validating_interest_for_Scenario_1')
      return
    end
    $log.logThis("PASSED: SCENARIO 1 COMPLETED")
  end
  
  def draw(dr)
    begin
      $log.logThis("Adding #{dr} Dollar Draw")
      $driver.find_element(:name, "transaction[amount]").send_keys(dr)
      $driver.save_screenshot($dir+'/'+"draw_#{dr}.png")
      $driver.find_element(:name, "commit").click()
      $wait
    rescue
      $log.processError('ERROR-Failed_Draw')
      return
    end    
  end
  
  def payment(py)
    begin
      $log.logThis("Adding #{py} Dollar Payment")
      $driver.find_element(:name, "transaction[type]").send_keys("p\n")
      $driver.find_element(:name, "transaction[applied_at]").send_keys("15\n")
      $driver.find_element(:name, "transaction[amount]").send_keys(py)
      $driver.save_screenshot($dir+'/'+"payment_#{py}.png")
      $driver.find_element(:name, "commit").click()
      $wait
    rescue
      $log.processError('ERROR-Failed_Payment')
      return
    end
  end
  
  def nlOfCredit2(crdLmt,creAPR,dr1,dr2,dr3,intAmt)
    $driver.navigate.to "http://credit-test.herokuapp.com/"
    createCreditLn(crdLmt,creAPR)
    source=$driver.page_source
    search="Line of credit was successfully created."
    begin
      valid=verifyContent(search,source)
      if(valid==true)
        draw(500)
        payment(200)
        draw(100)
      else
        $log.processError('ERROR-In_creditline_data_s2')
        return
      end
    rescue
      $log.logThis("Error in page search.")
    end
    # Verifying the final interest was calcuated correctly
    begin
      source=$driver.page_source
      valid=verifyContent(intAmt,source)
      if(valid==true)
        $log.logThis("Successfully calculated the interest for Scenario 2")
        $driver.save_screenshot($dir+'/'+'PASSED-SCENARIO_2_COMPLETED.png')
      else
        $log.processError('ERROR-FAILED-SCENARIO_2_COMPLETED')
        return
      end
    rescue
      $log.processError('ERROR-validating_interest_for_Scenario_2')
      return
    end
    $log.logThis("PASSED: SCENARIO 2 COMPLETED")
  end
end

class NegativeCase
  def validateNegCase
    source=$driver.page_source
    text='Listing Line Of Credits'
    $log.logThis("Testing Error Message with Alpha Characters Entered to create Credit Line.")
    begin
      if(source.include? text)
        $log.processError("Error Message Not Displayed.")
      else
        $log.logThis("PASSED: Error Message Displayed.")
        $driver.save_screenshot($dir+'/'+'PASSED-ERROR_MESSAGE_DISPLAYED_COMPLETED.png')
      end
    rescue
      $log.processError('ERROR-validateNegCase')
    end     
  end
  
  def exceedCrdLmt(amt)
    begin
      $se.createCreditLn(1000,35)
      $log.logThis("Testing making a $2000 draw on a $1000 credit limit.")
      $se.draw(2000)
      source=$driver.page_source
      text='$0.00 of $1,000.00'
      if(source.include? text)
        $log.logThis("PASSED: Transactions Not Processed!  Verify error message with image: "+
          'PASSED-ERROR_MESSAGE_DISPLAYED.png')
        $driver.save_screenshot($dir+'/'+'PASSED-ERROR_MESSAGE_DISPLAYED.png')
      else
        $log.processError("Error Message Not Displayed.")
      end      
    rescue
      $log.processError('ERROR-exceedCrdLmt')
    end
  end
end