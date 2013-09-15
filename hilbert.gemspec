# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hilbert/version'

Gem::Specification.new do |spec|
  spec.name          = "hilbert"
  spec.version       = Hilbert::VERSION
  spec.authors       = ["James Dabbs"]
  spec.email         = ["jamesdabbs@gmail.com"]
  spec.description   = "A simple first-order logic library"
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
