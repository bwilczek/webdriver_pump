module WebdriverPump
  module Wait
    @@timeout = 15
    @@interval = 0.2

    def self.timeout
      @@timeout
    end

    def self.timeout=(secs)
      @@timeout = secs
    end

    def self.interval
      @@interval
    end

    def self.interval=(secs)
      @@interval = secs
    end

    def self.until(*, timeout = @@timeout, interval = @@interval, &blk)
      start = Time.now
      while Time.now < (start + timeout.seconds)
        res = yield
        return res if res
        sleep interval
      end
      raise TimedOut.new
    end
  end
end
