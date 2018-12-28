module WebdriverPump
  module Wait
    def self.until(*, timeout=10, interval=0.2)
      start = Time.now
      while(Time.now < (start + timeout.seconds))
        pp "aaa"
        res = yield
        return res if res
        sleep interval
      end
      # TODO: create proper exception type
      raise "Timed out while waiting for condition to be true"
    end
  end
end
