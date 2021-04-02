require "selenium"
require "uri"

module WebdriverPump
  class Page < Component
    macro url(url)
      def url
        {{url}}
      end
    end

    def initialize(@session : Selenium::Session)
      # HACK: Fake root is required to match expected variable type. Proper one is set in #open
      @root = @session.find_element(:xpath, "//body")
    end

    def open(*, params : NamedTuple? = nil, query : NamedTuple? = nil, &blk : self -> _)
      processed_url = url
      if params
        params.each { |k, v| processed_url = processed_url.gsub("{#{k}}", URI.encode(v)) }
      end
      if query
        query_string = query.map { |k, v| "#{URI.encode(k.to_s)}=#{URI.encode(v)}" }.join("&")
        processed_url = "#{processed_url}?#{query_string}"
      end
      session.navigate_to(processed_url)
      @root = @session.find_element(:xpath, "//body")
      use(&blk)
    end

    def use
      wait.until { loaded? }
      yield self
    end

    def loaded?
      true
    end
  end
end
