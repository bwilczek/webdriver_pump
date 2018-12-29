module WebdriverPump
  module Wait
    # TODO: make time outs configurable
    def self.until(*, timeout=5, interval=0.2, &blk)
      start = Time.now
      while Time.now < (start + timeout.seconds)
        res = yield
        return res if res
        sleep interval
      end
      # TODO: create proper exception type
      raise "Timed out while waiting for condition to be true"
    end
  end
end
