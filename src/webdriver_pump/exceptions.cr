module WebdriverPump
  class UnsupportedFormElement < Exception
    def initialize(type)
      super("Unsupported form element: #{type}. See: Component#get_element_value")
    end
  end

  class TimedOut < Exception
    def initialize
      super("Timed out while waiting for condition to be true")
    end
  end

  class UnsupportedLocator < Exception
    def initialize(class_name)
      super("Unsupported locator (#{class_name}). Use NamedTuple (e.g. {id: 'name'}) or a Proc")
    end
  end

  class UnexpectedElementType < Exception
    def initialize(class_name)
      super("Given Proc returned a (#{class_name}) instead of Selenium::WebElement | Array(Selenium::WebElement)")
    end
  end
end
