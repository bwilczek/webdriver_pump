require "./spec_helper"

require "../src/webdriver_pump/page"

session_helper = WebdriverSessionHelper.new
session = session_helper.session

class GreeterPage < WebdriverPump::Page
  url "https://bwilczek.github.io/watir_pump_tutorial/greeter.html"
  element :header, { action: :text, locator: -> { root.find_element(:xpath, "//h1") } }
  element :fill_name, { action: :send_keys, locator: {id: "name"} }
  element :submit, { action: :click, locator: {id: "set_name"} }
  element :greeting, { action: :text, locator: {id: "greeting"} }
end

class ToDoListBasic < WebdriverPump::Component
  element :title, { action: :text, locator: {xpath: "//div[@role='title']"} }
  element :fill_item, { action: :send_keys, locator: {xpath: "//input[@role='new_item']"} }
  element :submit, { action: :click, locator: {xpath: "//button[@role='add']"} }
  elements :items, { locator: {xpath: "//span[@role='name']"} }

  def add(item)
    size_before = items.size
    fill_item(item)
    submit
    wait.until { items.size == size_before+1 }
  end
end

class ToDoListWithAjaxPage < WebdriverPump::Page
  url "https://bwilczek.github.io/watir_pump_tutorial/todo_list.html?random_delay=1"
  element :todo_list, { class: ToDoListBasic, locator: {xpath: "//div[@role='todo_list']"} }
end

#############################################

class ToDoListItem < WebdriverPump::Component
  element :name, { action: :text, locator: {xpath: ".//span[@role='name']"} }
  element :delete, { action: :click, locator: {xpath: ".//a[@role='rm']"} }
end

class ToDoListNested < WebdriverPump::Component
  element :title, { action: :text, locator: {xpath: ".//div[@role='title']"} }
  element :fill_item, { action: :send_keys, locator: {xpath: ".//input[@role='new_item']"} }
  element :submit, { action: :click, locator: {xpath: ".//button[@role='add']"} }
  elements :items, { class: ToDoListItem, locator: {xpath: ".//li"} }

  def add(item)
    size_before = items.size
    fill_item(item)
    submit
    wait.until { items.size == size_before+1 }
  end

  def [](item_name)
    ret = items.find { |i| i.name == item_name }
    raise "List item with name=#{item_name} not found" unless ret
    ret
  end
end

class ToDoListsPage < WebdriverPump::Page
  url "https://bwilczek.github.io/watir_pump_tutorial/todo_lists.html"
  elements :todo_lists, {
    class: ToDoListNested,
    locator: {xpath: "//div[@role='todo_list']"}
  }

  def list(title)
    ret = todo_lists.find { |l| l.title == title }
    raise "List with title=#{title} not found" unless ret
    ret
  end
end

##############################################

describe WebdriverPump do
  it "Page without components" do
    GreeterPage.new(session).open do |p|
      p.header.should eq "Greeter app"
      p.fill_name "Crystal"
      p.submit
      p.greeting.should eq "Hello Crystal!"
    end
  end

  it "Page with one component" do
    ToDoListWithAjaxPage.new(session).open do |p|
      p.todo_list.items.size.should eq 3
      p.todo_list.title.should eq "Groceries"
      p.todo_list.add("Mozarella")
      p.todo_list.items.size.should eq 4
    end
  end

  it "Page with multiple, nested components" do
    ToDoListsPage.new(session).open do |p|
      list = p.list("Groceries")
      list.add("Mozarella")
      list.items.size.should eq 4
      list["Mozarella"].delete
      list.items.size.should eq 3
    end
  end
end

session_helper.stop
