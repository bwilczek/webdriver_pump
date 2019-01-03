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
end
