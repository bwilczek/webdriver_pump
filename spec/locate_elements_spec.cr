require "./spec_helper"

session = WebdriverSessionHelper.session

##############################################

class ToDoListPageForElementLocators < WebdriverPump::Page
  url "#{WebdriverSessionHelper.base_url}/todo_list.html"

  element :title, {locator: {xpath: "//div[@role='title']"}}
  element :fill_item, {locator: {xpath: "//input[@role='new_item']"}}
  elements :items, {locator: {xpath: "//span[@role='name']"}}
  elements :items_lambda, {locator: ->{ root.find_child_elements(:xpath, "//span[@role='name']") }}
end

##############################################

describe WebdriverPump do
  it "single element with hash locator" do
    ToDoListPageForElementLocators.new(session).open do |p|
      p.title.displayed?.should be_true
      p.title.class.should eq Selenium::Element
    end
  end

  it "single element with lambda locator" do
    ToDoListPageForElementLocators.new(session).open do |p|
      p.fill_item.displayed?.should be_true
      p.fill_item.class.should eq Selenium::Element
    end
  end

  it "multiple elements with hash locator" do
    ToDoListPageForElementLocators.new(session).open do |p|
      p.items.first.displayed?.should be_true
      p.items.class.should eq Array(Selenium::Element)
    end
  end

  it "multiple elements with lambda locator" do
    ToDoListPageForElementLocators.new(session).open do |p|
      p.items_lambda.first.displayed?.should be_true
      p.items_lambda.class.should eq Array(Selenium::Element)
    end
  end
end
