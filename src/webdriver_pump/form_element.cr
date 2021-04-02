module WebdriverPump
  abstract class SimpleFormElement
    def initialize(@element : Selenium::Element)
    end

    abstract def value
    abstract def value=(val)
  end

  abstract class ComplexFormElement
    def initialize(@elements : Array(Selenium::Element))
    end

    abstract def value
    abstract def value=(val)
  end
end
