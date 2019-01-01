require "./spec_helper"

session = WebdriverSessionHelper.session

##############################################

class ToDoListPageForElementLocators < WebdriverPump::Page
  url "#{WebdriverSessionHelper.base_url}/todo_list.html"

  element :title, { locator: {xpath: "//div[@role='title']"} }
  element :fill_item, { locator: {xpath: "//input[@role='new_item']"} }
  elements :items, { locator: {xpath: "//span[@role='name']"} }
  elements :items_lambda, { locator: -> { root.find_elements(:xpath, "//span[@role='name']") } }

  element :unsupported_locator, { locator: 123 }
  element :unsupported_element_lambda, { locator: -> { 123 } }
  element :unsupported_elements_lambda, { locator: -> { 123 } }
end

##############################################

describe WebdriverPump do
  it "single element with hash locator" do
    ToDoListPageForElementLocators.new(session).open do |p|
      p.title.displayed?.should be_true
      p.title.class.should eq Selenium::WebElement
    end
  end

  it "single element with lambda locator" do
    ToDoListPageForElementLocators.new(session).open do |p|
      p.fill_item.displayed?.should be_true
      p.fill_item.class.should eq Selenium::WebElement
    end
  end

  it "multiple elements with hash locator" do
    ToDoListPageForElementLocators.new(session).open do |p|
      p.items.first.displayed?.should be_true
      p.items.class.should eq Array(Selenium::WebElement)
    end
  end

  it "multiple elements with lambda locator" do
    ToDoListPageForElementLocators.new(session).open do |p|
      p.items_lambda.first.displayed?.should be_true
      p.items_lambda.class.should eq Array(Selenium::WebElement)
    end
  end

  it "unsupported locator" do
    ToDoListPageForElementLocators.new(session).open do |p|
      expect_raises(WebdriverPump::UnsupportedLocator) do
        p.unsupported_locator
      end
    end
  end

  it "unsupported proc result for element" do
    ToDoListPageForElementLocators.new(session).open do |p|
      expect_raises(WebdriverPump::UnexpectedElementType) do
        p.unsupported_element_lambda
      end
    end
  end

  it "unsupported proc result for elements" do
    ToDoListPageForElementLocators.new(session).open do |p|
      expect_raises(WebdriverPump::UnexpectedElementType) do
        p.unsupported_elements_lambda
      end
    end
  end
end
