# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'growthpush/version'

Gem::Specification.new do |spec|
  spec.name          = 'growthpush'
  spec.version       = Growthpush::VERSION
  spec.authors       = ['Yasumasa Ashida']
  spec.email         = ['ys.ashida@gmail.com']
  spec.description   = %q{GrowthPush SDK for Ruby}
  spec.summary       = %q{GrowthPush is push notification and analysis platform for smart devices. GrowthPush SDK for Ruby provides registration function of client devices and events.}
  spec.homepage      = 'https://github.com/SIROK/growthpush-ruby'
  spec.license       = 'Apache License'

  spec.files         = `git ls-files`.split($/)
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', "~> 1.3"
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
end
