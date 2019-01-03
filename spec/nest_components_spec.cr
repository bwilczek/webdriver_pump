require "./spec_helper"

session = WebdriverSessionHelper.session

##############################################

class CollectionIndexedByTitle(T) < WebdriverPump::ComponentCollection(T)
  def [](title)
    ret = find { |el| el.title == title }
    raise "Component with title='#{title}' not found" unless ret
    ret
  end
end

class CollectionIndexedByName(T) < WebdriverPump::ComponentCollection(T)
  def [](name)
    ret = find { |el| el.name == name }
    raise "Component with name='#{name}' not found" unless ret
    ret
  end
end

class CollectionForShortElements(T) < WebdriverPump::ComponentCollection(T)
  def shortest
    shortest = first.text
    each do |el|
      shortest = el.text if el.text.size < shortest.size
    end
    shortest
  end
end

##############################################

class ToDoListsItemForNesting < WebdriverPump::Component
  element :name, {locator: {xpath: ".//span[@role='name']"}, action: :text}
  element :delete, {locator: {xpath: ".//a[@role='rm']"}, action: :click}
end

class ToDoListsForNesting < WebdriverPump::Component
  element :title, {locator: {xpath: ".//div[@role='title']"}, action: :text}
  element :fill_item, {action: :send_keys, locator: {xpath: ".//input[@role='new_item']"}}
  element :submit, {action: :click, locator: {xpath: ".//button[@role='add']"}}
  elements :items, {
    class:            ToDoListsItemForNesting,
    locator:          {xpath: ".//li"},
    collection_class: CollectionIndexedByName(ToDoListsItemForNesting),
  }
  elements :raw_items, {
    locator:          {xpath: ".//li//span"},
    collection_class: CollectionForShortElements(Selenium::WebElement),
  }

  def add(item)
    size_before = items.size
    fill_item(item)
    submit
    wait.until { items.size == size_before + 1 }
  end

  def delete(item)
    size_before = items.size
    items[item].delete
    wait.until { items.size == size_before - 1 }
  end
end

class ToDoListsPageForNesting < WebdriverPump::Page
  url "#{WebdriverSessionHelper.base_url}/todo_lists.html?random_delay=1"

  elements :todo_lists, {
    class:            ToDoListsForNesting,
    locator:          {xpath: ".//div[@role='todo_list']"},
    collection_class: CollectionIndexedByTitle(ToDoListsForNesting),
  }
end

##############################################

describe WebdriverPump do
  it "components can be nested" do
    ToDoListsPageForNesting.new(session).open do |p|
      p.todo_lists["Home"].items["Dishes"].class.should eq ToDoListsItemForNesting
    end
  end

  it "component collection can be decorated" do
    ToDoListsPageForNesting.new(session).open do |p|
      p.todo_lists["Home"].title.should eq "Home"
    end
  end

  it "element collection can be decorated" do
    ToDoListsPageForNesting.new(session).open do |p|
      p.todo_lists["Groceries"].raw_items.shortest.should eq "Bread"
    end
  end

  it "element actions are supported" do
    ToDoListsPageForNesting.new(session).open do |p|
      p.todo_lists["Groceries"].add("Avocado")
      p.todo_lists["Groceries"].items.size.should eq 4
      p.todo_lists["Groceries"].delete("Avocado")
      p.todo_lists["Groceries"].items.size.should eq 3
    end
  end
end
