module WebdriverPump
  alias ElementLocator = Proc(Selenium::WebElement) | NamedTuple(id: String) | NamedTuple(xpath: String) | NamedTuple(name: String) | NamedTuple(class_name: String) | NamedTuple(css: String) | NamedTuple(tag_name: String) | NamedTuple(link_text: String) | NamedTuple(partial_link_text: String)
  alias ElementsLocator = Proc(Array(Selenium::WebElement)) | NamedTuple(id: String) | NamedTuple(xpath: String) | NamedTuple(name: String) | NamedTuple(class_name: String) | NamedTuple(css: String) | NamedTuple(tag_name: String) | NamedTuple(link_text: String) | NamedTuple(partial_link_text: String)

  module LocateElement
    getter :root

    def locate_element(locator : ElementLocator)
      if locator.is_a?(Proc)
        return locator.call
      else # locator.is_a?(NamedTuple)
        by = locator.keys.first
        selector = locator.values.first
        return @root.find_element(by, selector)
      end
    end

    def locate_elements(locator : ElementsLocator)
      if locator.is_a?(Proc)
        locator.call
      else # locator.is_a?(NamedTuple)
        by = locator.keys.first
        selector = locator.values.first
        return @root.find_elements(by, selector)
      end
    end
  end
end
