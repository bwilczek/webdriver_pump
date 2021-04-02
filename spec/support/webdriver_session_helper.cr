require "selenium"

class WebdriverSessionHelper
  @@session : Selenium::Session | Nil

  def self.base_url
    "https://bwilczek.github.io/watir_pump_tutorial"
  end

  def self.session
    @@session ||= begin
      chrome_options = Selenium::Chrome::Capabilities::ChromeOptions.new
      chrome_options.args = ["no-sandbox", "disable-gpu"]

      capabilities = Selenium::Chrome::Capabilities.new
      capabilities.chrome_options = chrome_options

      chromedriver_path = `which chromedriver`.chomp

      driver = Selenium::Driver.for(:chrome, service: Selenium::Service.chrome(driver_path: chromedriver_path))
      session = driver.create_session(capabilities)

      Spec.after_suite do
        driver.stop
      end
      session
    end
  end
end
