# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendyr/version'

Gem::Specification.new do |spec|
  spec.name          = "sendyr"
  spec.version       = Sendyr::VERSION
  spec.authors       = ["Carl Mercier"]
  spec.email         = ["carl@carlmercier.com"]
  spec.summary       = %q{A Ruby interface for the wonderful e-mail newsletter application Sendy.}
  spec.homepage      = "http://github.com/cmer/sendyr"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "require_all"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
end
