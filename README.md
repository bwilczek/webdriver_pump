# WORK IN PROGRESS !!

# webdriver_pump

This shard is a Page Object Model lib, built on top of selenium-webdriver.
It's a crystal port of ruby's watir_pump.

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  webdriver_pump:
    github: bwilczek/webdriver_pump
```
2. Run `shards install`

## Usage

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

See `/spec` for details.

## Development

- [x] Page without Components
- [x] Declare raw WebDriver elements with webdriver locators
- [x] Declare raw WebDriver elements with lambdas
- [x] Declare actions on WebDriver elements
- [x] Declare reusable Components
- [x] Collections of elements
- [ ] Collections of Components
- [ ] Nest Components
- [x] Wait for AJAX-driven Components to be ready to interact
- [ ] Fill in complex forms: RadioGroups, SelectLists
- [ ] Parametrize Page url
- [ ] Support `loaded?` predicate for Pages
- [ ] Add support for base url
- [ ] Port WatirPump's form helpers (?)
- [ ] Upload files (?)

## Contributing

1. Fork it (<https://github.com/bwilczek/webdriver_pump/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Test your changes, add relevant specs
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## Contributors

- [Bartek Wilczek](https://github.com/bwilczek) - creator and maintainer
