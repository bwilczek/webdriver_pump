module WebdriverPump
  class Checkbox < FormElement
    @element : Selenium::WebElement

    def initialize(@root, @locator)
      super
      @element = locate_element(@locator.as(ElementLocator))
    end

    def value
      @element.selected?
    end

    def value=(val)
      @element.click if @element.selected? != val
    end
  end
end
