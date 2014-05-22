# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'four_tell'

Gem::Specification.new do |spec|
  spec.name          = "four_tell"
  spec.version       = FourTell::VERSION
  spec.authors       = ["Jon-Michael Deldin"]
  spec.email         = ["dev@jmdeldin.com"]
  spec.summary       = "Ruby bindings to the 4-Tell API."
  spec.homepage      = "https://github.com/TheClymb/four_tell"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "excon", "> 0.27"
  spec.add_dependency 'net-http-persistent', '~> 2.9.4'
end
