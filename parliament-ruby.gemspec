# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parliament/version'

Gem::Specification.new do |spec|
  spec.name          = 'parliament-ruby'
  spec.version       = Parliament::VERSION
  spec.authors       = ['Matt Rayner']
  spec.email         = ['mattrayner1@gmail.com']
  spec.summary       = %q{Internal parliamentary API wrapper}
  spec.description   = %q{Internal parliamentary data API wrapper for ruby}
  spec.homepage      = 'http://github.com/ukparliament/parliament_ruby'
  spec.license       = 'Nonstandard'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'grom', '~> 0.3.6'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.47'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.3'
end
