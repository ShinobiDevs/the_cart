# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_cart/version'

Gem::Specification.new do |spec|
  spec.name          = "the_cart"
  spec.version       = TheCart::VERSION
  spec.authors       = ["Elad Meidar"]
  spec.email         = ["elad@eizesus.com"]
  spec.summary       = "Cart implementation in Redis"
  spec.description   = "Online cart implementation in redis"
  spec.homepage      = "https://github.com/ShinobiDevs/the_cart"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_dependency 'redis'
end
