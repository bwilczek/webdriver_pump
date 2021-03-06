module WebdriverPump
  class Checkbox < SimpleFormElement
    def value
      @element.selected?
    end

    def value=(val)
      @element.click if @element.selected? != val
    end
  end
end
