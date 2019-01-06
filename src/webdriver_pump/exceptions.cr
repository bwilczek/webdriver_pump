module WebdriverPump
  # Raised on invalid class provided to form_element macro
  class InvalidFormElementException < Exception
    def initialize(class_name)
      super("Given class '#{class_name}' is neiter child of SimpleFormElement or ComplexFormElement")
    end
  end

  # Raised on Timeout
  class TimedOutException < Exception
    def initialize
      super("Timed out while waiting for condition to be true")
    end
  end
end
