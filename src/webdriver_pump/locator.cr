module WebdriverPump
  alias ElementLocator = Proc(Selenium::WebElement) | NamedTuple(id: String) | NamedTuple(xpath: String) | NamedTuple(name: String) | NamedTuple(class_name: String) | NamedTuple(css: String) | NamedTuple(tag_name: String) | NamedTuple(link_text: String) | NamedTuple(partial_link_text: String)
  alias ElementsLocator = Proc(Array(Selenium::WebElement)) | NamedTuple(id: String) | NamedTuple(xpath: String) | NamedTuple(name: String) | NamedTuple(class_name: String) | NamedTuple(css: String) | NamedTuple(tag_name: String) | NamedTuple(link_text: String) | NamedTuple(partial_link_text: String)
end
