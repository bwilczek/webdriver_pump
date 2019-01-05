module WebdriverPump
  class RadioGroup < Elements
    def value
      @elements.each do |el|
        next unless el.selected?
        begin
          label = el.find_element(:xpath, "./parent::label")
        rescue
          id = el.attribute("id")
          label = el.find_element(:xpath, "//label[@for='#{id}']")
        end
        return label.text
      end
    end

    def value=(val)
      @elements.each do |el|
        begin
          label = el.find_element(:xpath, "./parent::label")
        rescue
          id = el.attribute("id")
          label = el.find_element(:xpath, "//label[@for='#{id}']")
        end
        if label.text == val
          label.click
          return
        end
      end
    end
  end
end
