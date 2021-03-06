require 'fileutils'

class CreateSeleniumConnetion
  def makeBroswer()
    begin
      $log=Logging.new
      $driver=Selenium::WebDriver.for:firefox
      $wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      $driver.navigate.to "http://credit-test.herokuapp.com/"
      $driver.save_screenshot($dir+'/'+'OpeningPage.png')
      $log.logThis("Page title is #{$driver.title}")
    rescue
      $log.processError('ERROR-makeBrowser')
    end
  end   
end

class Logging
  def processError(err)
    begin
      logThis(err)
      $driver.save_screenshot($dir+'/'+'ERROR-'+err+'.png')
    end
  end
  
  def makeDir()
    tm=Time.now.strftime("%m%d%Y%H%M%S")
    header="Written by Otto Von Bailey\nIDE: Eclipse Neon.3 Release (4.6.3)\nBegin Log: "+Time.now.strftime("%m/%d/%Y %H:%M:%S")+"\n"
    $dir='Log_'+tm
    $fn='logFile'+tm+'.log'
    FileUtils::mkdir_p $dir
    File.write($dir+'/'+$fn,header)
  end
  
  def logThis(comment)
    puts(comment)
    open($dir+'/'+$fn,'a'){ |f|
    f.puts Time.now.strftime("%m/%d/%Y %H:%M:%S")+': '+comment
    }
  end
end

def verifyContent(x,y)
  begin
    if(y.include? x)
      logThis("Correct Amount of interest discovered.")
      return true
    else
      logThis("Incorrect Amount of interest discovered.")
      return false
    end
  rescue
    processError('ERROR-verifyContent')
  end     
end

