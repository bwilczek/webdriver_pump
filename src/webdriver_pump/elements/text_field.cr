module WebdriverPump
  class TextField < SimpleFormElement
    def value
      @element.property("value")
    end

    def value=(val)
      @element.send_keys(val)
    end
  end

  alias TextArea = TextField
end
