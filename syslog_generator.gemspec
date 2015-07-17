# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'syslog_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "syslog_generator"
  spec.version       = SyslogGenerator::VERSION
  spec.authors       = ["Michael Parks"]
  spec.email         = ["mparks@tkware.info"]
  spec.summary       = %q{Generates random syslog data for configuration testing}
  spec.description   = %q{Uses random_word to send configurable, nonsense syslog data at a server of your choice. Great for testing your logger configuration.}
  spec.license       = "Apache License v2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
