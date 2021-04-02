module WebdriverPump
  class MultiSelectList < SimpleFormElement
    def value
      ret = Array(String).new
      @element.find_child_elements(:xpath, ".//option").each do |option|
        ret << option.text if option.selected?
      end
      ret
    end

    def value=(val)
      @element.find_child_elements(:xpath, ".//option").each do |option|
        option.click if option.selected?
        if val.includes?(option.text)
          option.click
        end
      end
    end
  end
end
