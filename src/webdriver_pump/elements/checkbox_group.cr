module WebdriverPump
  class CheckboxGroup < Elements
    def value
      ret = Array(String).new
      @elements.each do |el|
        next unless el.selected?
        begin
          label = el.find_element(:xpath, "./parent::label")
        rescue
          id = el.attribute("id")
          label = el.find_element(:xpath, "//label[@for='#{id}']")
        end
        ret << label.text
      end
      ret
    end

    def value=(val)
      @elements.each do |el|
        begin
          label = el.find_element(:xpath, "./parent::label")
        rescue
          id = el.attribute("id")
          label = el.find_element(:xpath, "//label[@for='#{id}']")
        end
        label.click if el.selected?
        label.click if val.includes?(label.text)
      end
    end
  end
end
