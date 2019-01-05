module WebdriverPump
  abstract class Elements
    def initialize(@elements : Array(Selenium::WebElement))
    end

    abstract def value
    abstract def value=(val)
  end
end
