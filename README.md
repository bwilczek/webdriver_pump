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
describe WebdriverPump do
  it "Page without components" do
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

under construction

### Overview

under construction

### Page

under construction

### Component

under construction

#### `#element`

under construction

##### locator

under construction

##### action

under construction

##### class

under construction

#### `#elements`

under construction

##### locator

under construction

##### collection_class

under construction

#### Form helper macros

under construction

##### element_getter and element_setter

under construction

##### fill_form and form_data

under construction

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
