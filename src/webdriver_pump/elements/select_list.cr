module WebdriverPump
  class SelectList < SimpleFormElement
    def value
      @element.find_elements(:xpath, ".//option").each do |option|
        return option.text if option.selected?
      end
    end

    def value=(val)
      @element.find_elements(:xpath, ".//option").each do |option|
        option.click if option.selected?
        if val.includes?(option.text)
          option.click
        end
      end
    end
  end
end
