module WebdriverPump
  # Raised on Timeout
  class TimedOut < Exception
    def initialize
      super("Timed out while waiting for condition to be true")
    end
  end
end
