require "selenium"

require "./component"

module WebdriverPump
  class Page < Component
    macro url(url)
      def url
        {{url}}
      end
    end

    def initialize(@session : Selenium::Session)
      # Fake root required to match expected types. Proper one is set in #open
      @root = Selenium::WebElement.new(@session, JSON.parse(%({"ELEMENT": "body"})).as_h)
    end

    def open(&blk : self -> _)
      session.url = url
      @root = @session.find_element(:xpath, "//body")
      use(&blk)
    end

    def use
      # TODO: wait until loaded?
      yield self
    end

    def loaded?
      true
    end
  end
end
