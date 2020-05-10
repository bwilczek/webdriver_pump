require "selenium/webdriver"

class WebdriverSessionHelper
  @@session : Selenium::Session | Nil

  def self.base_url
    "https://bwilczek.github.io/watir_pump_tutorial"
  end

  def self.session
    @@session ||= begin
      chromedriver = Process.new("chromedriver", args: {"--port=4444", "--url-base=/wd/hub"})
      sleep 1
      capabilities = {
        browserName: "chrome",
        platform:    "ANY",
      }
      driver = Selenium::Webdriver.new
      session = Selenium::Session.new(driver, capabilities)

      Spec.after_suite do
        session.stop
      end
      session
    end
  end
end
