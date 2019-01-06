module WebdriverPump
  class TextField < FormElement
    @element : Selenium::WebElement

    def initialize(@root, @locator)
      super
      @element = locate_element(@locator.as(ElementLocator))
    end

    def value
      @element.attribute("value")
    end

    def value=(val)
      @element.send_keys(val)
    end
  end

  alias TextArea = TextField
end
