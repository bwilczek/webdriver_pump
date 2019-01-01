# webdriver_pump

This shard is a Page Object Model lib, built on top of [selenium-webdriver-crystal](https://github.com/ysbaddaden/selenium-webdriver-crystal).
It's a crystal port of ruby's watir_pump.

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  webdriver_pump:
    github: bwilczek/webdriver_pump
```
2. Run `shards install`

## Basic usage

```crystal
require "webdriver_pump"

# define the page model, for example:
class GreeterPage < WebdriverPump::Page
  url "https://bwilczek.github.io/watir_pump_tutorial/greeter.html"
  element :header, { action: :text, locator: -> { root.find_element(:xpath, "//h1") } }
  element :fill_name, { action: :send_keys, locator: {id: "name"} }
  element :submit, { action: :click, locator: {id: "set_name"} }
  element :greeting, { action: :text, locator: {id: "greeting"} }
end

# use it in specs, for example:
# where `session` is an instance of Selenium::Session
describe "Page without components" do
  it "operates on Selenium::WebElements" do
    GreeterPage.new(session).open do |p|
      p.header.should eq "Greeter app"
      p.fill_name "Crystal"
      p.submit
      p.greeting.should eq "Hello Crystal!"
    end
  end
end
```

## Documentation

Please refer to this chapter to learn how to define your Page Objects, and use it from your tests.

### Overview

`WebdriverPump` provides a DSL (implemented as macros) to describe the Page Object Model.
It's a very close port of Ruby's `WatirPump` gem. There are some subtle differences in the implementation,
but the core concepts remain the same:

* **Nestable, reusable components**, to build elegant APIs
* **Element actions**, to automatically generate simple, one liner methods (like wrappers for `click`)
* **Page scoping**, so that it's immediately known what `page` is currently being tested
* **Form helpers**, to operate HTML form elements with ease (WebDriver doesn't deliver here)
* **Decorated collections**, to access element/component collections with descriptive keys

### Page

Describes the page under test. Inherits from `Component`, so please familiarize yourself
with that class as well to fully understand what `Page` is capable of. This section covers
only the differences from the base `Component` class.

#### `url` macro

Declares the full URL to the page under test.

```crystal
class GitHubUserPage < WebdriverPump::Page
  url "https://github.com/bwilczek"
end

describe "Page's URL" do
  it "navigates to given URL" do
    GitHubUserPage.new(session).open do |p|
      session.url.should eq "https://github.com/bwilczek"
    end
  end
end
```

URL can be parameterized:

```crystal
class GitHubUserPage < WebdriverPump::Page
  url "https://github.com/{user}"
end

describe "Page's URL" do
  it "navigates to given parameterized URL" do
    GitHubUserPage.new(session).open(params: {user: "bwilczek"}, query: {repo: "webdriver_pump""}) do |p|
      session.url.should eq "https://github.com/bwilczek?repo=webdriver_pump"
    end
  end
end
```

#### `#open`

Navigates to Page's URL and executes given block in the scope of the page.

```crystal
class GitHubUserPage < WebdriverPump::Page
  url "https://github.com/bwilczek"
  element :user_nickname, { locator: { xpath:, "//span[@itemprop='additionalName']") } }
end

describe "Page's URL" do
  it "navigates to given URL" do
    GitHubUserPage.new(session).open do |page|
      page.class.should eq GitHubUserPage
      page.user_nickname.class.should eq Selenium::WebElement
      page.user_nickname.text.should eq "bwilczek"
    end
  end
end
```

#### `#use`

Similar to `#open`, but does not perform the navigation - assumes that the page is already open.
Useful when the navigation is triggered by an action on a different page.

```crystal
GitHubUserPage.new(session).open do { |p| p.navigate_to_repo("webdriver_pump") }

GitHubRepoPage.new(session).use do |p|
  p.class.should eq GitHubRepoPage
end
```

#### `#loaded`

Predicate method denoting if page is ready to be interacted with.

In most cases creation of this method will not be required, since `WebDriver` itself
checks if page's resources have been loaded. Only in case of more complex pages,
that heavily rely on parts loaded dynamically over XHR providing of custom `loaded?`
criteria might be necessary.

```crystal
class GitHubUserPage < WebdriverPump::Page
  url "https://js-heavy.com"
  element :created_by_xhr, { locator: {id: "content"} }

  def loaded?
    created_by_xhr.displayed?
  end
end
```

### Component

*section under construction*

#### `#session`

*section under construction*

#### `#root`

*section under construction*

#### `#wait`

*section under construction*

#### `element` macro

*section under construction*

##### locator

*section under construction*

##### action

*section under construction*

##### class

*section under construction*

#### `elements` macro

*section under construction*

##### locator

*section under construction*

##### collection_class

*section under construction*

#### Form helper macros

*section under construction*

##### element_getter and element_setter

*section under construction*

##### fill_form and form_data

*section under construction*

## Development roadmap

- [x] Page without Components
- [x] Declare raw WebDriver elements with webdriver locators
- [x] Declare raw WebDriver elements with lambdas
- [x] Declare actions on WebDriver elements
- [x] Declare reusable Components
- [x] Collections of elements
- [x] Collections of Components
- [x] Nest Components
- [x] Wait for AJAX-driven Components to be ready to interact
- [x] ComponentCollection class
- [x] Fill in complex forms: RadioGroups, SelectLists
- [x] Parametrize Page url
- [x] Support `loaded?` predicate for Pages
- [x] ~Add support for base url~ do it on `webdriver` shard level
- [x] Port WatirPump's form helpers
- [x] Introduce Exception classes
- [ ] Upload files (?)
- [ ] Update README
- [ ] Update code documentation

## Contributing

1. Fork it (<https://github.com/bwilczek/webdriver_pump/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Test your changes, add relevant specs
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## Contributors

- [Bartek Wilczek](https://github.com/bwilczek) - creator and maintainer
