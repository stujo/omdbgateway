# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "omdbgateway"
  spec.version       = '0.0.1'
  spec.authors       = ["Stuart Jones"]
  spec.email         = ["omdbgateway@skillbox.com"]
  spec.description   = 'A Service Gateway for the omdbapi.com movie API.'
  spec.summary       = 'Based on the outline of Casey Scarborough\'s excellent omdbapi gem, I wanted a project practice faraday and ended up with a rewrite, with substantial changes to the API so to avoid confusion I renamed the gem'
  spec.homepage      = "https://github.com/stujo/omdbgateway/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "simplecov", "~> 0.8"
  spec.add_development_dependency "vcr", "~> 2.9"

  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "webmock", "~> 1.17"

  spec.add_dependency 'faraday', "~> 0.8"
  spec.add_dependency "faraday_middleware", "~> 0.9"
end
