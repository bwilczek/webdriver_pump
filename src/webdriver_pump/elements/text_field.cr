module WebdriverPump
  class TextField < Element
    def value
      @element.attribute("value")
    end

    def value=(val)
      @element.send_keys(val)
    end
  end

  alias TextArea = TextField
end
