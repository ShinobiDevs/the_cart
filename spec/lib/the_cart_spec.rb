require 'spec_helper'

describe TheCart do

  describe "#configure" do

    it "should default to a redis connection" do
      TheCart.configure do
      end

      TheCart.redis.should_not be_nil
    end

  end

end