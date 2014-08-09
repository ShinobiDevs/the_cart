require "the_cart/version"
require 'the_cart/configuration'
require 'the_cart/shopper'
require 'the_cart/item'

require 'redis'
module TheCart

  attr_reader :configuration
  
  def self.configure(&block)
    @configuration = TheCart::Configuration.new
    yield(@configuration)
  end

  def self.redis
    @configuration.redis ||= Redis.new
  end

end
