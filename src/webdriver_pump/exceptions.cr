module WebdriverPump
  class UnsupportedFormElement < Exception
    def initialize(type)
      super("Unsupported form element: #{type}. See: Component#get_element_value")
    end
  end
end
