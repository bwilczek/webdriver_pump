require "selenium/webdriver"

class WebdriverSessionHelper
  getter session : Selenium::Session
  getter driver : Selenium::Webdriver
  getter chromedriver : Process

  def initialize
    @chromedriver = Process.new("chromedriver", args: {"--port=4444", "--url-base=/wd/hub"})
    sleep 1
    capabilities = {
      browserName: "chrome",
      platform: "ANY"
    }
    @driver = Selenium::Webdriver.new
    @session = Selenium::Session.new(driver, capabilities)
  end

  def stop
    @session.stop
    @chromedriver.kill
  end
end
