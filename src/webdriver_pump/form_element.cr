module WebdriverPump
  abstract class FormElement
    include LocateElement

    def initialize(@root : Selenium::WebElement, @locator : ElementLocator | ElementsLocator)
    end

    abstract def value
    abstract def value=(val)
  end
end
