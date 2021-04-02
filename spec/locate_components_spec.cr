require "./spec_helper"

session = WebdriverSessionHelper.session

##############################################

class ToDoListForComponentLocators < WebdriverPump::Component
  element :title, {locator: {xpath: ".//div[@role='title']"}, action: :text}

  def info
    "info"
  end
end

class ToDoListsPageForComponentLocators < WebdriverPump::Page
  url "#{WebdriverSessionHelper.base_url}/todo_lists.html"

  element :todo_list_one, {
    class:   ToDoListForComponentLocators,
    locator: {css: "#todos_home"},
  }
  element :todo_list_two, {
    class:   ToDoListForComponentLocators,
    locator: ->{ root.find_child_element(:css, "#todos_work") },
  }
  elements :todo_lists, {
    class:   ToDoListForComponentLocators,
    locator: {xpath: ".//div[@role='todo_list']"},
  }
  elements :todo_lists_lambda, {
    class:   ToDoListForComponentLocators,
    locator: ->{ root.find_child_elements(:xpath, ".//div[@role='todo_list']") },
  }
  element :todo_list_info, {
    class:   ToDoListForComponentLocators,
    locator: {css: "#todos_home"},
    action:  :info,
  }
end

##############################################

describe WebdriverPump do
  it "single component with hash locator" do
    ToDoListsPageForComponentLocators.new(session).open do |p|
      p.todo_list_one.class.should eq ToDoListForComponentLocators
      p.todo_list_one.root.displayed?.should be_true
      p.todo_list_one.title.should eq "Home"
    end
  end

  it "single component with lambda locator" do
    ToDoListsPageForComponentLocators.new(session).open do |p|
      p.todo_list_two.class.should eq ToDoListForComponentLocators
      p.todo_list_two.root.displayed?.should be_true
      p.todo_list_two.title.should eq "Work"
    end
  end

  it "multiple component with hash locator" do
    ToDoListsPageForComponentLocators.new(session).open do |p|
      p.todo_lists.class.should eq Array(ToDoListForComponentLocators)
      p.todo_lists.first.class.should eq ToDoListForComponentLocators
      p.todo_lists.first.title.should eq "Home"
    end
  end

  it "multiple components with lambda locator" do
    ToDoListsPageForComponentLocators.new(session).open do |p|
      p.todo_lists_lambda.class.should eq Array(ToDoListForComponentLocators)
      p.todo_lists_lambda.last.class.should eq ToDoListForComponentLocators
      p.todo_lists_lambda.last.title.should eq "Groceries"
    end
  end

  it "component actions are supported" do
    ToDoListsPageForComponentLocators.new(session).open do |p|
      p.todo_list_info.should eq "info"
    end
  end
end
