# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'send_cloud/version'

Gem::Specification.new do |spec|
  spec.name          = "send_cloud"
  spec.version       = SendCloud::VERSION
  spec.authors       = ["john.li"]
  spec.email         = ["john.li@rccchina.com"]
  spec.summary       = %q{gem for send_cloud}
  spec.description   = %q{use send_cloud to send edm or ordinary email}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
