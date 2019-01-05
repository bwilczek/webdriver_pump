module WebdriverPump
  abstract class Element
    def initialize(@element : Selenium::WebElement)
    end

    abstract def value
    abstract def value=(val)
  end
end
