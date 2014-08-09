module TheCart
  class Configuration
    attr_accessor :redis

    def initialize
      @redis = nil
    end
  end
end