module WebdriverPump
  class ComponentCollection(T)
    def initialize(@collection : Array(T))
    end

    forward_missing_to @collection
  end
end
